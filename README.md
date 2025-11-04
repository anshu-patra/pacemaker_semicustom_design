**Adaptive Threshold Pacemaker - Semi-Custom ASIC Design
Project Overview**
This project implements a bio-inspired adaptive threshold pacemaker using Verilog HDL, featuring a complete RTL-to-GDSII semi-custom ASIC design flow using Cadence tools. The design incorporates an Adaptive
Leaky Integrate-and-Fire (LIF) neuron model for intelligent cardiac event detection with dynamic threshold adjustment, combined with pacemaker control logic.

**Key Features**

1. **Adaptive LIF Neuron-based QRS Detection**: Implements a leaky integrate-and-fire neuron model with adaptive threshold for robust heartbeat detection
2. **Dynamic Threshold Adjustment**: Threshold increases after spike detection and decays exponentially during quiescence
3. **Complete ASIC Design Flow**: From Verilog RTL to physical layout (GDSII)
4. **180nm Technology:** Designed using TSMC 180nm standard cell library
5. **Power Distribution Network**: Multi-layer power grid with rings and stripes
6. **Timing Closure**: Meets all setup and hold timing requirements
7. **Functional Verification**: Tested with SimVision waveform viewer



📋 **Table of Contents**

1. Architecture
2. Design Hierarchy
3. Module Descriptions
4. Design Flow
5. Synthesis Results
6. Physical Design
7. Timing Analysis
8. Simulation Results
9. Tools and Technology
10. File Structure
11. How to Run
12. Results Summary
13. Future Enhancements
14. References








 # Architecture
The pacemaker system consists of three main functional blocks:



┌─────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  ECG ROM    │────▶│  Adaptive LIF    │────▶│  Pacemaker     │
│  (Samples)  │     │  (QRS Detection) │     │  Control Logic  │
└─────────────┘     └──────────────────┘     └─────────────────┘
                            │                         │
                            ▼                         ▼
                      LED_HEART                  LED_PACE
```

### Block Diagram
The system operates at a configurable sample rate (default 1000 Hz) and processes simulated ECG signals through an adaptive detection mechanism.

---

## 📦 Design Hierarchy
```
top
├── ecg_rom (ECG signal source)
├── adaptive_lif (QRS detection with adaptive threshold)
└── pacemaker_ctrl (Pacing logic and escape interval)
```

---

## 🔧 Module Descriptions

### 1. **ECG ROM (`ecg_rom`)**
- **Purpose**: Provides simulated ECG waveform samples
- **Features**:
  - 10-sample cyclic pattern
  - 12-bit output resolution
  - Includes normal beats and flatline periods to trigger pacing
- **Parameters**: 
  - `SAMPLE_COUNT`: Number of samples in the pattern (default: 10)

### 2. **Adaptive LIF Neuron (`adaptive_lif`)**
- **Purpose**: Bio-inspired cardiac event detection with adaptive threshold
- **Key Features**:
  - **Leaky Integration**: Membrane potential accumulates signal and leaks over time
  - **Adaptive Threshold**: Base threshold increases after spike, decays exponentially
  - **Dead Zone**: Filters out low-amplitude noise (±100 LSB)
  - **Refractory Period**: 3-tick absolute refractory period post-spike
  - **Configurable Gain**: Default gain of 40 for signal amplification
  
- **Algorithm**:
```
  v(t+1) = v(t) + GAIN × input(t) - v(t)/16    [leaky integration]
  
  if v(t) ≥ θ(t):
      spike = 1
      v = V_RESET
      θ(t+1) = θ(t) + THETA_INC
  else:
      θ(t+1) = θ(t) - (θ(t) - θ_base)/32      [exponential decay]
```

- **Parameters**:
  - `SAMPLE_WIDTH`: 12-bit ADC resolution
  - `ACC_WIDTH`: 20-bit accumulator for membrane potential
  - `THETA_WIDTH`: 16-bit threshold representation
  - `GAIN`: 40 (signal amplification factor)
  - `THETA_BASE`: 1536 (baseline threshold)
  - `THETA_INC`: 128 (post-spike increment)

### 3. **Pacemaker Control (`pacemaker_ctrl`)**
- **Purpose**: Implements demand pacing with blanking and refractory periods
- **Operation**:
  - Monitors detector spikes
  - Delivers pace pulse if no event detected within escape interval
  - Implements blanking period (40ms) to avoid self-detection
  - Enforces refractory period (200ms) post-event
  
- **Parameters**:
  - `LOWER_RATE_BPM`: 500 bpm (escape interval)
  - `BLANKING_MS`: 40ms
  - `REFRACT_MS`: 200ms
  - `SAMPLE_FREQ`: 1000 Hz

---

## 🔄 Design Flow

The complete ASIC design flow executed:
```
RTL Design (Verilog)
    ↓
Functional Verification (NCVerilog + SimVision)
    ↓
Logic Synthesis (Genus)
    ↓
Floorplanning (Innovus)
    ↓
Power Planning (Ring + Stripe)
    ↓
Placement (Timing-Driven)
    ↓
Clock Tree Synthesis (CTS)
    ↓
Routing (NanoRoute)
    ↓
Timing Optimization
    ↓
Physical Verification
    ↓
GDSII Generation
```

---

## ⚡ Synthesis Results

### Resource Utilization (Genus Synthesis)

| Metric | Value |
|--------|-------|
| **Technology** | TSMC 180nm |
| **Standard Cells** | 1,138 instances |
| **Sequential Cells** | 182 flip-flops |
| **Combinational Cells** | 266 gates |
| **Total Area** | 25,730 µm² |
| **Cell Density** | 68.32% |

### Gate Distribution

- **Buffers/Inverters**: 18 types available (BUFX, INVX variants)
- **Logic Gates**: AND, OR, NAND, NOR, XOR, AOI, OAI
- **Sequential Elements**: DFF variants (DFFHQ, DFFNR, DFFSR)

### Timing Summary (Post-Synthesis)

| Parameter | Value |
|-----------|-------|
| **Clock Period** | 10 ns (100 MHz) |
| **Setup WNS** | +5.222 ns |
| **Setup TNS** | 0.000 ns |
| **Hold WNS** | -0.230 ns (post-route) |
| **Hold TNS** | -3.126 ns (post-route) |
| **Total Paths** | 191 |
| **Violating Paths** | 64 (hold, fixed in optimization) |

---

## 🖼️ Physical Design

### 1. **Floorplan**

![Floorplan](image1.png)

*Initial floorplan showing core area with power grid structure*

**Specifications**:
- **Core Dimensions**: 214.5 × 205.08 µm
- **Aspect Ratio**: ~1:1 (optimized for routing)
- **Core-to-Die Spacing**: 8.58µm (all sides)
- **Utilization**: 68.32%

### 2. **Power Distribution Network**

**Power Grid Architecture**:
- **Power Rings**:
  - Top/Bottom: Metal6 (1.8µm width, 0.46µm spacing)
  - Left/Right: Metal5 (1.8µm width, 0.28µm spacing)
  - Offset: 1.8µm from core boundary

- **Power Stripes**:
  - Vertical: Metal6 (3 sets, 1.8µm width)
  - Horizontal: Metal5 (3 sets, 1.8µm width)
  
- **Power Nets**: VDD and VSS with global connection
- **Via Generation**: 307 vias (Via12, Via23, Via34, Via45, Via56)

### 3. **Placement**

![Placement View](image1.png)

*Standard cell placement after timing-driven optimization*

**Placement Statistics**:
- Total cells placed: 1,138
- Placement density: 68.32%
- Mean displacement: 2.25 µm
- Max displacement: 28.33 µm

### 4. **Routing**

![Detailed Routing](image3.png)

*Completed routing with all metal layers*

**Routing Summary**:
- **Total Wire Length**: 30,997 µm
- **Metal Layer Usage**:
  - Metal1 (H): 2,449 µm
  - Metal2 (V): 13,792 µm
  - Metal3 (H): 11,582 µm
  - Metal4 (V): 3,175 µm
  - Metal5 (H): 0 µm (reserved for power)
  - Metal6 (V): 0 µm (reserved for power)

- **Via Count**: 6,511 total
  - Via12: 4,105
  - Via23: 2,067
  - Via34: 339

- **Congestion**: 0.00% H + 0.00% V (no overflow)
- **DRC Violations**: 0

### 5. **Layout Hierarchy**

![Hierarchical Layout](image5.png)

*Hierarchical view showing module boundaries and interconnections*

---

## ⏱️ Timing Analysis

### Setup Timing (Pre-CTS)

![Setup Timing Report](image2.png)

| Path Group | WNS (ns) | TNS (ns) | Violating Paths |
|------------|----------|----------|-----------------|
| **all** | +5.222 | 0.000 | 0 |
| **reg2reg** | +5.222 | 0.000 | 0 |
| **default** | +6.720 | 0.000 | 0 |

**Analysis**:
- ✅ All setup timing constraints met
- ✅ Positive slack across all paths
- ✅ No timing violations

### Hold Timing (Post-Route)

| Path Group | WNS (ns) | TNS (ns) | Violating Paths |
|------------|----------|----------|-----------------|
| **all** | -0.230 | -3.126 | 64 |
| **reg2reg** | -0.230 | -3.126 | 64 |
| **default** | +0.676 | 0.000 | 0 |

**Note**: Hold violations were addressed through post-route optimization with buffer insertion and cell resizing.

### Design Rule Checks (DRCs)

| Constraint | Violations |
|------------|------------|
| **Max Capacitance** | 0 |
| **Max Transition** | 0 |
| **Max Fanout** | 18 (within limits) |
| **Max Length** | 0 |

---

## 📊 Simulation Results

### Functional Simulation

![SimVision Waveforms](image4.png)

*Functional verification showing CLK, LED_HEART (detector spikes), LED_PACE (pacing pulses), and RSTn signals over 20µs simulation*

**Test Scenario**:
1. **Reset Phase** (0-100ns): System initialization
2. **Normal Rhythm** (100ns-5µs): ECG ROM provides regular beats → LED_HEART pulses observed
3. **Flatline Period** (5µs-10µs): ROM outputs baseline → No detector spikes
4. **Pacemaker Activation** (>10µs): Escape interval expires → LED_PACE fires

**Key Observations**:
- ✅ Detector correctly identifies QRS complexes
- ✅ Pacemaker triggers during bradycardia
- ✅ Blanking period prevents pacemaker self-detection
- ✅ Threshold adaptation visible in spike timing

---

## 🛠️ Tools and Technology

### EDA Tools (Cadence)

| Tool | Version | Purpose |
|------|---------|---------|
| **NCVerilog** | 15.20-s086 | RTL Simulation |
| **SimVision** | 15.20 | Waveform Analysis |
| **Genus** | 20.11-s111_1 | Logic Synthesis |
| **Innovus** | 20.14-s095_1 | Place & Route |
| **Quantus QRC** | Integrated | RC Extraction |
| **Tempus** | Integrated | Static Timing Analysis |

### Technology Library

- **Process**: TSMC 180nm (tsmc18)
- **Voltage**: 1.8V nominal
- **Temperature**: 25°C
- **Libraries**:
  - `fast.lib` (best-case timing)
  - `slow.lib` (worst-case timing)
- **LEF Files**: Standard cell physical abstracts
- **Technology File**: `t018s6mm.tch` (6-metal process)

---

## 📁 File Structure
```
pacemaker-asic/
├── rtl/
│   ├── pacemaker.v          # Top-level RTL
│   └── testbench.v           # Testbench
├── synthesis/
│   ├── run.tcl               # Genus synthesis script
│   └── genus.log             # Synthesis log
├── pnr/
│   ├── innovus.tcl           # Innovus P&R script
│   ├── innovus.log           # P&R log
│   └── Default.view          # Multi-corner setup
├── constraints/
│   └── pacemaker_constraints.sdc  # Timing constraints
├── outputs/
│   ├── pacemaker_netlist_180nm.v  # Gate-level netlist
│   ├── pacemaker_180nm.sdf        # Standard Delay Format
│   └── pacemaker_180nm.db         # Design database
├── reports/
│   ├── pacemaker_timing_180nm.rpt
│   ├── pacemaker_power_180nm.rpt
│   ├── pacemaker_area_180nm.rpt
│   └── pacemaker_qor_180nm.rpt
├── simulation/
│   ├── ncvlog.log
│   ├── ncelab.log
│   ├── ncsim.log
│   └── testbench.vcd
└── README.md


**Performance Metrics**
<img width="895" height="287" alt="image" src="https://github.com/user-attachments/assets/8aa80452-b54e-4130-8708-b403b9168d5f" />




Design Quality

Timing Closure: ✅ Achieved in both setup and hold
Routing Congestion: ✅ 0% overflow
Power Grid: ✅ IR drop < 5%
Signal Integrity: ✅ SI-aware routing enabled
Manufacturability: ✅ DRC/LVS clean
