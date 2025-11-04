#--------------------------#
# Library Setup
#--------------------------#
set_db init_lib_search_path {/home/install/FOUNDRY/digital/180nm/dig/lib/}
set_db library fast.lib

#--------------------------#
# Read Physical Info (optional)
#--------------------------#
# read_physical -lef /path/to/tech.lef

#--------------------------#
# Read RTL
#--------------------------#
read_hdl ./pacemaker.v

#--------------------------#
# Elaborate Top-Level
#--------------------------#
elaborate top

if {[current_design] == ""} {
    puts "ERROR: Elaboration failed!"
    exit 1
}
puts "INFO: Current design is [current_design]"

check_design -unresolved

#--------------------------#
# Read Constraints
#--------------------------#
read_sdc ./pacemaker_constraints.sdc
puts "INFO: SDC constraints loaded successfully"
check_timing_intent

#--------------------------#
# Synthesis Efforts
#--------------------------#
set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high

set_db optimize_constant_0_flops true
set_db optimize_constant_1_flops true

#--------------------------#
# Run Synthesis Stages
#--------------------------#
puts "INFO: Starting Synthesis..."
syn_generic
syn_map
syn_opt

#--------------------------#
# Output Directories
#--------------------------#
file mkdir outputs
file mkdir reports

#--------------------------#
# Write Results
#--------------------------#
write_hdl > outputs/pacemaker_netlist_180nm.v
write_sdc > outputs/pacemaker_output_180nm.sdc
write_sdf > outputs/pacemaker_180nm.sdf
write_db -to_file outputs/pacemaker_180nm.db

#--------------------------#
# Reports
#--------------------------#
report_timing -nworst 20 -max_paths 20 > reports/pacemaker_timing_180nm.rpt
report_power > reports/pacemaker_power_180nm.rpt
report_area -detail > reports/pacemaker_area_180nm.rpt
report_gates > reports/pacemaker_gates_180nm.rpt
report_qor > reports/pacemaker_qor_180nm.rpt
report_hierarchy > reports/pacemaker_hierarchy.rpt
report_summary > reports/pacemaker_summary.rpt
report_clock_gating > reports/pacemaker_clock_gating.rpt
report_instance > reports/pacemaker_instance.rpt
check_design -multiple_driver > reports/multiple_drivers.rpt

#--------------------------#
# Timing/Mapping Checks
#--------------------------#
set timing_ok [check_timing -verbose]
if {$timing_ok != 0} {
    puts "WARNING: Timing violations detected! Check timing report."
}
set unmapped [get_db [get_db insts -if {.is_unmapped == true}]]
if {[llength $unmapped] > 0} {
    puts "ERROR: Unmapped cells found!"
    report_unmapped > reports/unmapped_cells.rpt
}

puts "SYNTHESIS SUMMARY"
puts "Design: [current_design]"
puts "Technology: 180nm"
puts "Total Cells: [get_db insts -count]"
puts "Total Nets: [get_db nets -count]"
puts "Total Ports: [get_db ports -count]"
set wns [get_db timing_analysis_type -if {.type == max_timing} .slack]
set tns [get_db timing_analysis_type -if {.type == max_timing} .total_negative_slack]
puts "Worst Negative Slack (WNS): $wns"
puts "Total Negative Slack (TNS): $tns"
set total_area [get_db current_design .area]
puts "Total Area: $total_area"
puts "INFO: Synthesis completed successfully!"
puts "INFO: Check reports/ directory for detailed analysis"
