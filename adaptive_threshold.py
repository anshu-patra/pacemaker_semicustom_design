# =========================================
# Adaptive-Threshold SNN Pacemaker Simulation (Final Tuned Version)
# =========================================
!pip install numpy matplotlib scipy -q

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, filtfilt

# -------------------------
# ECG signal generator
# -------------------------
def generate_intrinsic_ecg(duration_s=20.0, fs=250, base_hr=60, jitter=0.05,
                           drop_prob=0.0, ectopic_prob=0.0):
    t = np.arange(0, duration_s, 1/fs)
    ecg = np.zeros_like(t)
    beat_interval = 60.0 / base_hr
    next_beat = 0.0
    while next_beat < duration_s:
        jittered = next_beat + np.random.normal(0, jitter*beat_interval)
        if jittered < 0:
            next_beat += beat_interval
            continue
        if np.random.rand() < drop_prob:
            next_beat += beat_interval
            continue
        idx = int(round(jittered * fs))
        if idx < len(ecg):
            width = max(1, int(0.02 * fs))
            for i in range(width):
                if idx + i < len(ecg):
                    ecg[idx+i] += (1.0 - i/width) * 1.0
        if np.random.rand() < ectopic_prob:
            extra = jittered + np.random.uniform(0.2*beat_interval, 0.5*beat_interval)
            idx2 = int(round(extra * fs))
            if idx2 < len(ecg):
                width = max(1, int(0.02 * fs))
                for i in range(width):
                    if idx2 + i < len(ecg):
                        ecg[idx2+i] += (0.8 - i/width) * 1.0
        next_beat += beat_interval
    ecg += 0.05 * np.sin(2*np.pi*0.25*t)      # baseline drift
    ecg += 0.02 * np.random.randn(len(t))     # noise
    return t, ecg

def bandpass(sig, fs, low=0.5, high=40.0, order=3):
    nyq = 0.5*fs
    b, a = butter(order, [low/nyq, high/nyq], btype='band')
    return filtfilt(b, a, sig)

# -------------------------
# Adaptive LIF neuron (detector)
# -------------------------
class AdaptiveLIFDetector:
    def __init__(self, fs=250, dt=None,
                 tau_m=0.03, tau_theta=0.7,
                 theta_base=0.15, theta_inc=0.25,
                 v_reset=0.0, v_rest=0.0,
                 gain=10.0,
                 dead_zone=0.18,
                 refractory_ms=150,
                 homeo_rate=0.0008,
                 target_spikes_per_sec=1.0,
                 homeo_window_s=6.0):
        self.fs = fs
        self.dt = (1/fs) if dt is None else dt
        self.tau_m = tau_m
        self.tau_theta = tau_theta
        self.theta_base = theta_base
        self.theta_inc = theta_inc
        self.v_reset = v_reset
        self.v_rest = v_rest
        self.gain = gain
        self.dead_zone = dead_zone
        self.refractory_s = refractory_ms / 1000.0
        self.homeo_rate = homeo_rate
        self.target_spikes_per_sec = target_spikes_per_sec
        self.homeo_window_s = homeo_window_s
        self.spike_times = []

    def reset(self, length):
        self.v = np.zeros(length)
        self.theta = np.ones(length) * self.theta_base
        self.spike_times = []

    def run(self, ecg_filtered):
        T = len(ecg_filtered)
        self.reset(T)
        ecg_shifted = ecg_filtered - np.min(ecg_filtered)
        if np.max(ecg_shifted) > 0:
            ecg_shifted /= (np.max(ecg_shifted) + 1e-12)
        med = np.median(ecg_shifted)
        mad = np.median(np.abs(ecg_shifted - med)) + 1e-9
        ecg_std = (ecg_shifted - med) / mad
        ecg_std = np.clip(ecg_std, -5.0, 10.0)
        I_t = self.gain * np.clip(ecg_std - self.dead_zone, 0.0, None)

        spikes = np.zeros(T, dtype=int)
        last_spike_time = -1e9
        for t in range(T-1):
            dv = self.dt * (-(self.v[t] - self.v_rest) / self.tau_m + I_t[t])
            self.v[t+1] = self.v[t] + dv

            refractory = ((t/self.fs) - last_spike_time) < self.refractory_s
            if not refractory and self.v[t+1] >= self.theta[t]:
                spikes[t+1] = 1
                last_spike_time = t/self.fs
                self.v[t+1] = self.v_reset
                self.theta[t+1] = self.theta[t] + self.theta_inc
                self.spike_times.append((t+1)/self.fs)
            else:
                dth = self.dt * (-(self.theta[t] - self.theta_base) / self.tau_theta)
                self.theta[t+1] = self.theta[t] + dth

            if (t % int(self.homeo_window_s * self.fs)) == 0 and t > 0:
                now = (t+1)/self.fs
                wins = [s for s in self.spike_times if s >= now - self.homeo_window_s]
                rate = len(wins) / max(1e-9, self.homeo_window_s)
                delta = self.homeo_rate * (self.target_spikes_per_sec - rate)
                self.theta_base = np.clip(self.theta_base + delta, 0.001, 1.0)
        return I_t, self.v, self.theta, spikes

# -------------------------
# Pacemaker controller (VVI mode)
# -------------------------
class PacemakerController:
    def __init__(self, fs=250, mode='VVI', lower_rate_bpm=50,
                 blanking_ms=40, refractory_ms=200,
                 pulse_amplitude_mV=2.5, pulse_width_ms=0.5,
                 capture_threshold_mV=1.1):
        self.fs = fs
        self.mode = mode
        self.escape_interval_s = 60.0 / lower_rate_bpm
        self.blanking_s = blanking_ms / 1000.0
        self.refractory_s = refractory_ms / 1000.0
        self.pulse_amp = pulse_amplitude_mV
        self.pulse_width_s = pulse_width_ms / 1000.0
        self.capture_threshold = capture_threshold_mV
        self.reset()

    def reset(self):
        self.last_event_time = -1e9
        self.blank_until = -1e9
        self.refract_until = -1e9
        self.pacing_history, self.sensed_history = [], []

    def step(self, t_s, detector_spike):
        pace = captured = accepted = False
        if detector_spike and t_s >= self.blank_until and t_s >= self.refract_until:
            self.sensed_history.append(t_s)
            self.last_event_time = t_s
            self.refract_until = t_s + self.refractory_s
            accepted = True
        time_since_last = t_s - self.last_event_time
        if time_since_last >= self.escape_interval_s:
            pace = True
            self.last_event_time = t_s
            self.blank_until = t_s + self.blanking_s
            cap_prob = 1.0 / (1.0 + np.exp(-3.0 * (self.pulse_amp - self.capture_threshold)))
            captured = (np.random.rand() < cap_prob)
            self.pacing_history.append((t_s, captured))
        return pace, captured, accepted

# -------------------------
# Closed-loop simulation
# -------------------------
def run_closed_loop(duration_s=20.0, fs=250, intrinsic_hr=60,
                    detector_params=None, pm_params=None, seed=42):
    np.random.seed(seed)
    t, intrinsic_ecg = generate_intrinsic_ecg(duration_s, fs, intrinsic_hr)
    ecg_filt = bandpass(intrinsic_ecg, fs, 0.5, 40.0)

    detector = AdaptiveLIFDetector(fs=fs, **(detector_params or {}))
    pacemaker = PacemakerController(fs=fs, **(pm_params or {}))

    obs_ecg = ecg_filt.copy()
    N = len(t)
    I_t, v, theta, spikes = detector.run(obs_ecg)
    paced_times, captured_times, sensed_times = [], [], []

    for i in range(N):
        t_s = t[i]
        detector_spike = (spikes[i] == 1)
        pace, captured, accepted = pacemaker.step(t_s, detector_spike)
        if accepted:
            sensed_times.append(t_s)
        if pace and captured:
            paced_times.append(t_s)
            captured_times.append(t_s)
            width = max(1, int(pacemaker.pulse_width_s * fs))
            for j in range(width):
                if i + j < N:
                    obs_ecg[i+j] += 0.9 * (1 - j/width)
            I_t, v, theta, spikes = detector.run(obs_ecg)
    return dict(t=t, intrinsic_ecg=ecg_filt, obs_ecg=obs_ecg,
                I_t=I_t, v=v, theta=theta, spikes=spikes,
                paced_times=paced_times, captured_times=captured_times,
                sensed_times=sensed_times, pacemaker=pacemaker, detector=detector)

# -------------------------
# Run demonstration
# -------------------------
sim = run_closed_loop(duration_s=20.0, fs=250, intrinsic_hr=60,
                      detector_params=dict(
                          gain=3.0,
                          theta_base=0.15,
                          theta_inc=0.35,
                          tau_theta=0.7,
                          dead_zone=0.65,
                          homeo_rate=0.0008,
                          target_spikes_per_sec=1.0,
                          homeo_window_s=6.0,
                          refractory_ms=180),
                      pm_params=dict(
                          lower_rate_bpm=50,
                          blanking_ms=40,
                          refractory_ms=200,
                          pulse_amplitude_mV=2.5,
                          pulse_width_ms=0.5,
                          capture_threshold_mV=1.1),
                      seed=7)

# -------------------------
# Plot results
# -------------------------
t = sim['t']
fig, axs = plt.subplots(5, 1, figsize=(14, 10), sharex=True)
axs[0].plot(t, sim['intrinsic_ecg'], label="Intrinsic ECG", color="tab:orange", alpha=0.8)
axs[0].plot(t, sim['obs_ecg'], label="Observed ECG", color="tab:red", alpha=0.6)
axs[0].legend(); axs[0].set_ylabel("ECG (a.u.)")

axs[1].plot(t, sim['I_t']); axs[1].set_ylabel("Input current I(t)")
axs[2].plot(t, sim['v'], label='v'); axs[2].plot(t, sim['theta'], '--', label='θ')
axs[2].legend(); axs[2].set_ylabel("v / θ")
axs[3].eventplot([t[sim['spikes']==1]], colors='k'); axs[3].set_ylabel("SNN spikes")
axs[4].plot(t, sim['obs_ecg'], color='gray', alpha=0.4)
for pt in sim['paced_times']:
    axs[4].axvline(pt, color='tab:blue', linestyle='--', label='Paced' if pt==sim['paced_times'][0] else "")
for ct in sim['captured_times']:
    axs[4].axvline(ct, color='tab:green', linestyle='-', label='Captured' if ct==sim['captured_times'][0] else "")
axs[4].legend(); axs[4].set_ylabel("Pacing events"); axs[4].set_xlabel("Time (s)")
plt.tight_layout(); plt.show()

# -------------------------
# Print summary
# -------------------------
paced = len(sim['paced_times'])
captured = len(sim['captured_times'])
sensed = len(sim['sensed_times'])
total_intrinsic = np.count_nonzero(sim['spikes'])
print(f"Sensed intrinsic detector spikes (total): {total_intrinsic}")
print(f"Paced pulses delivered: {paced}")
print(f"Pacing captures (evoked beats): {captured}")
if paced > 0:
    print(f"Capture rate = {100*captured/paced:.1f}%")
print(f"Sensed_times (accepted by controller): {sensed}")
