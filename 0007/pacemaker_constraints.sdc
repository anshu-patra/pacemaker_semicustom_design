# Clock Definition for 'CLK'
create_clock -name CLK -period 10.0 [get_ports CLK]
set_clock_uncertainty -setup 0.5 [get_clocks CLK]
set_clock_uncertainty -hold 0.3 [get_clocks CLK]
set_clock_latency -source 1.0 [get_clocks CLK]
set_clock_latency -max 0.5 [get_clocks CLK]
set_clock_transition 0.2 [get_clocks CLK]

# Input/Output Delays (Setup/Hold) - excluding clock
set all_inputs_except_clk [remove_from_collection [all_inputs] [get_ports CLK]]
set_input_delay -max 2.0 -clock CLK $all_inputs_except_clk
set_input_delay -min 0.5 -clock CLK $all_inputs_except_clk
set_output_delay -max 2.0 -clock CLK [all_outputs]
set_output_delay -min 0.5 -clock CLK [all_outputs]

# Drive/Load, Transition, Capacitance, Fanout
set_driving_cell -lib_cell BUFX2 -library fast [all_inputs]
set_load 0.2 [all_outputs]
set_max_capacitance 0.5 [all_nets]
set_max_transition 1.5 [current_design]
set_max_fanout 8 [current_design]
set_max_capacitance 0.3 [all_inputs]

# Ensure async reset path is false - replace RSTn/RESETn as needed
set_false_path -from [get_ports RSTn]

# Grouping Path Reports
group_path -name reg2reg -from [all_registers] -to [all_registers]

# Ideal and protected clock network
set_ideal_network [get_ports CLK]
set_dont_touch_network [get_ports CLK]

# Derate for variation
set_timing_derate -early 0.95
set_timing_derate -late 1.05

# OCV derating for clock
set_timing_derate -early 0.97 -clock
set_timing_derate -late 1.03 -clock
