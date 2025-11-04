#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Mon Nov  3 10:58:16 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.14-s095_1 (64bit) 04/19/2021 14:41 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.14-s095_1 NR210411-1939/20_14-UB (database version 18.20.547) {superthreading v2.13}
#@(#)CDS: AAE 20.14-s018 (64bit) 04/19/2021 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.14-s027_1 () Apr 13 2021 21:29:07 ( )
#@(#)CDS: SYNTECH 20.14-s017_1 () Mar 25 2021 13:07:27 ( )
#@(#)CDS: CPE v20.14-s080
#@(#)CDS: IQuantus/TQuantus 20.1.1-s460 (64bit) Fri Mar 5 18:46:16 PST 2021 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
getVersion
getVersion
win
set init_gnd_net VSS
set init_lef_file ../../../install/FOUNDRY/digital/180nm/dig/lef/all.lef
set init_design_settop 0
set init_verilog outputs/pacemaker_netlist_180nm.v
set init_mmmc_file Default.view
set init_pwr_net VDD
init_design
getIoFlowFlag
setIoFlowFlag 0
floorPlan -site tsm3site -r 1 0.7 6 6 6 6
uiSetTool select
getIoFlowFlag
fit
setIoFlowFlag 0
floorPlan -site tsm3site -r 0.997188378632 0.699494 6.6 6.16 6.6 6.16
uiSetTool select
getIoFlowFlag
fit
getIoFlowFlag
setIoFlowFlag 0
floorPlan -site tsm3site -r 1 0.7 8 8 8 8
uiSetTool select
getIoFlowFlag
fit
setIoFlowFlag 0
floorPlan -site tsm3site -r 0.997188378632 0.699494 8.58 8.4 8.58 8.4
uiSetTool select
getIoFlowFlag
fit
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -instanceBasename * -hierarchicalInstance {}
globalNetConnect VSS -type pgpin -pin VSS -instanceBasename * -hierarchicalInstance {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer Metal6 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top Metal6 bottom Metal6 left Metal5 right Metal5} -width {top 1.8 bottom 1.8 left 1.8 right 1.8} -spacing {top 0.46 bottom 0.46 left 0.28 right 0.28} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer Metal6 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top Metal6 bottom Metal6 left Metal5 right Metal5} -width {top 1.8 bottom 1.8 left 1.8 right 1.8} -spacing {top 0.46 bottom 0.46 left 0.28 right 0.28} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal6 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD VSS} -layer Metal6 -direction vertical -width 1.8 -spacing 0.46 -number_of_sets 3 -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal6 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal6 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal6 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD VSS} -layer Metal5 -direction horizontal -width 1.8 -spacing 0.28 -number_of_sets 3 -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal6 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal6 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal6 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD VSS} -layer Metal5 -direction horizontal -width 1.8 -spacing 0.28 -number_of_sets 3 -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal6 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal6 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { Metal1(1) Metal6(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { Metal1(1) Metal6(6) } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { Metal1(1) Metal6(6) }
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { Metal1(1) Metal6(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { Metal1(1) Metal6(6) } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { Metal1(1) Metal6(6) }
setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setNanoRouteMode -quiet -droutePostRouteSpreadWire 1
setNanoRouteMode -quiet -timingEngine {}
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {DLY4X1 DLY3X1 DLY2X1 DLY1X1 CLKBUFXL CLKBUFX8 CLKBUFX4 CLKBUFX3 CLKBUFX20 CLKBUFX2 CLKBUFX16 CLKBUFX12 CLKBUFX1 BUFXL BUFX8 BUFX4 BUFX3 BUFX20 BUFX2 BUFX16 BUFX12 BUFX1 INVXL INVX8 INVX4 INVX3 INVX20 INVX2 INVX16 INVX12 INVX1 CLKINVXL CLKINVX8 CLKINVX4 CLKINVX3 CLKINVX20 CLKINVX2 CLKINVX16 CLKINVX12 CLKINVX1} -maxAllowedDelay 1
setPlaceMode -reset
setPlaceMode -congEffort auto -timingDriven 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 0 -placeIOPins 1 -moduleAwareSpare 0 -preserveRouting 1 -rmAffectedRouting 0 -checkRoute 0 -swapEEQ 0
setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {DLY4X1 DLY3X1 DLY2X1 DLY1X1 CLKBUFXL CLKBUFX8 CLKBUFX4 CLKBUFX3 CLKBUFX20 CLKBUFX2 CLKBUFX16 CLKBUFX12 CLKBUFX1 BUFXL BUFX8 BUFX4 BUFX3 BUFX20 BUFX2 BUFX16 BUFX12 BUFX1 INVXL INVX8 INVX4 INVX3 INVX20 INVX2 INVX16 INVX12 INVX1 CLKINVXL CLKINVX8 CLKINVX4 CLKINVX3 CLKINVX20 CLKINVX2 CLKINVX16 CLKINVX12 CLKINVX1} -maxAllowedDelay 1
setPlaceMode -fp false
place_design
setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {BUFX1 BUFX12 BUFX16 BUFX2 BUFX20 BUFX3 BUFX4 BUFX8 BUFXL CLKBUFX1 CLKBUFX12 CLKBUFX16 CLKBUFX2 CLKBUFX20 CLKBUFX3 CLKBUFX4 CLKBUFX8 CLKBUFXL DLY1X1 DLY2X1 DLY3X1 DLY4X1 CLKINVX1 CLKINVX12 CLKINVX16 CLKINVX2 CLKINVX20 CLKINVX3 CLKINVX4 CLKINVX8 CLKINVXL INVX1 INVX12 INVX16 INVX2 INVX20 INVX3 INVX4 INVX8 INVXL} -maxAllowedDelay 1
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithLithoDriven 1
setNanoRouteMode -quiet -routeWithSiDriven 1
setNanoRouteMode -quiet -routeTopRoutingLayer 6
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
setNanoRouteMode -quiet -drouteEndIteration 1
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -preCTS
getCTSMode -engine -quiet
create_ccopt_clock_tree_spec
ctd_win -side none -id ctd_window -unit_delay
zoomSelected
selectInst {lif_inst/theta_reg[13]}
zoomSelected
deselectInst {lif_inst/theta_reg[13]}
selectInst {lif_inst/theta_reg[13]}
zoomSelected
zoomBox 99.88250 74.51050 171.28200 138.42850
zoomBox 55.76000 45.32750 216.67700 189.38250
zoomBox -16.86650 -2.70900 291.40000 273.25550
zoomBox -75.83700 -43.29900 350.82950 338.65850
deselectAll
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix top_preCTS -outDir timingReports
setAnalysisMode -checkType hold
setAnalysisMode -cppr both -clockGatingCheck true -timeBorrowing true -useOutputPinCap true -sequentialConstProp false -timingSelfLoopsNoSkew false -enableMultipleDriveNet true -clkSrcPath true -warn true -usefulSkew true -analysisType onChipVariation -log true
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix top_postRoute -outDir timingReports
ui_view_box
ui_view_box
dbquery -area {-75.837 -43.299 350.8295 338.6585} -objType inst
dbquery -area {-75.837 -43.299 350.8295 338.6585} -objType regular
dbquery -area {-75.837 -43.299 350.8295 338.6585} -objType special
fit
setDrawView place
