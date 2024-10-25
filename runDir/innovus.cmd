#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sun May 26 16:04:48 2024                
#                                                     
#######################################################

#@(#)CDS: Innovus v22.32-s080_1 (64bit) 04/24/2023 15:07 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 22.32-s080_1 NR230417-0429/22_12-UB (database version 18.20.608_1) {superthreading v2.20}
#@(#)CDS: AAE 22.12-s030 (64bit) 04/24/2023 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 22.12-s023_1 () Apr 21 2023 10:35:13 ( )
#@(#)CDS: SYNTECH 22.12-s011_1 () Apr 21 2023 10:00:03 ( )
#@(#)CDS: CPE v22.12-s075
#@(#)CDS: IQuantus/TQuantus 21.2.2-s138 (64bit) Fri Mar 24 13:17:38 PDT 2023 (Linux 3.10.0-693.el7.x86_64)

#@ source ../SCRIPTS/import.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/import.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
set_db init_power_nets VDD
set_db init_ground_nets VSS
read_mmmc $data_dir/mmmc/dtmf.mmmc
#@ Begin verbose source ../INPUTS/mmmc/dtmf.mmmc (pre)
create_library_set -name default_libset_max\
   -timing\
    [list ../INPUTS/lib/rom_512x16A_slow_syn.lib\
    ../INPUTS/lib/tpz973gwc-lite_slow.lib\
    ../INPUTS/lib/ram_256x16A_slow_syn.lib\
    ../INPUTS/lib/ram_128x16A_slow_syn.lib\
    ../INPUTS/lib/slow.lib\
    ../INPUTS/lib/pllclk_slow.lib]\
   -si\
    [list ../INPUTS/CDB/slow.cdb]
create_library_set -name default_libset_min\
   -timing\
    [list ../INPUTS/lib/ram_256x16A_fast_syn.lib\
    ../INPUTS/lib/pllclk_fast.lib\
    ../INPUTS/lib/ram_128x16A_fast_syn.lib\
    ../INPUTS/lib/fast.lib\
    ../INPUTS/lib/rom_512x16A_fast_syn.lib\
    ../INPUTS/lib/tpz973gbc-lite_fast.lib]\
   -si\
    [list ../INPUTS/CDB/fast.cdb]
create_timing_condition -name default_mapping_tc_2\
   -library_sets [list default_libset_min]
create_timing_condition -name default_mapping_tc_1\
   -library_sets [list default_libset_max]
create_rc_corner -name default_rc_corner_worst\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -qrc_tech ../INPUTS/QRC/t018s6mm.tch
create_delay_corner -name default_delay_corner_max\
   -timing_condition {default_mapping_tc_1}\
   -rc_corner default_rc_corner_worst
create_delay_corner -name default_delay_corner_ocv\
   -early_timing_condition {default_mapping_tc_2}\
   -late_timing_condition {default_mapping_tc_1}\
   -rc_corner default_rc_corner_worst
create_delay_corner -name default_delay_corner_min\
   -timing_condition {default_mapping_tc_2}\
   -rc_corner default_rc_corner_worst
create_constraint_mode -name default_constraint_mode\
   -sdc_files\
    [list ../INPUTS/constraints/dtmf.sdc]
create_analysis_view -name default_analysis_view_setup -constraint_mode default_constraint_mode -delay_corner default_delay_corner_max
create_analysis_view -name default_analysis_view_hold -constraint_mode default_constraint_mode -delay_corner default_delay_corner_min
set_analysis_view -setup [list default_analysis_view_setup] -hold [list default_analysis_view_hold]
#@ End verbose source ../INPUTS/mmmc/dtmf.mmmc
read_physical -lef {../INPUTS/lef/all.lef}
read_netlist $data_dir/verilog/dtmf_chip_ak.v
init_design
read_io_file $data_dir/fp/dtmf.io
create_floorplan -site tsm3site -core_size 842 842 100 100 100 100
gui_fit
write_db -sdc $dbs_dir/import.db
#@ End verbose source: ../SCRIPTS/import.tcl
#@ source ../SCRIPTS/place_macro.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/place_macro.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
create_relative_floorplan -place DTMF_INST/PLLCLK_INST -ref_type core_boundary -horizontal_edge_separate {3 20 3} -vertical_edge_separate {0 20 0} 
create_relative_floorplan -place DTMF_INST/RAM_256x16_TEST_INST/RAM_256x16_INST -ref_type core_boundary -horizontal_edge_separate {0 3 0} -vertical_edge_separate {2 -37 2} -orient R270
create_relative_floorplan -place DTMF_INST/RAM_128x16_TEST_INST/RAM_128x16_INST -ref_type core_boundary -horizontal_edge_separate {2 -37 2} -vertical_edge_separate {3 -37 3}
create_relative_floorplan -place DTMF_INST/ARB_INST/ROM_512x16_0_INST -ref_type core_boundary -horizontal_edge_separate {1 -45 1} -vertical_edge_separate {0 3 0} -orient R90
create_place_halo -halo_deltas {20 20 20 20} -all_blocks
write_db -sdc $dbs_dir/place_macro.db
#@ End verbose source: ../SCRIPTS/place_macro.tcl
#@ source ../SCRIPTS/create_power_grid.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/create_power_grid.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
connect_global_net VDD -type pgpin -pin VDD -all
connect_global_net VSS -type pgpin -pin VSS -all
connect_global_net VDD -type tiehi
connect_global_net VSS -type tielo
set_layer_preference pinObj -is_visible 1
set_db add_rings_target default ;
set_db add_rings_extend_over_row 0 ;
set_db add_rings_ignore_rows 0 ;
set_db add_rings_avoid_short 0 ;
set_db add_rings_skip_shared_inner_ring none ;
set_db add_rings_stacked_via_top_layer Metal6 ;
set_db add_rings_stacked_via_bottom_layer Metal1 ;
set_db add_rings_via_using_exact_crossover_size 1 ;
set_db add_rings_orthogonal_only true ;
set_db add_rings_skip_via_on_pin {  standardcell } ;
set_db add_rings_skip_via_on_wire_shape {  noshape }
add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal5 bottom Metal5 left Metal6 right Metal6} -width {top 8 bottom 8 left 8 right 8} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1 bottom 1 left 1 right 1} -center 0 -extend_corners {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
select_obj [get_db insts *DTMF_INST/PLLCLK_INST]
add_rings -nets {VDD VSS} -type block_rings -around selected -layer {top Metal5 bottom Metal5 left Metal6 right Metal6} -width {top 8 bottom 8 left 8 right 8} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1 bottom 1 left 1 right 1} -center 0 -extend_corners {bl lb} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
gui_deselect -all
set_db add_stripes_ignore_block_check false ;
set_db add_stripes_break_at {  none  } ;
set_db add_stripes_route_over_rows_only false ;
set_db add_stripes_rows_without_stripes_only false ;
set_db add_stripes_extend_to_closest_target none ;
set_db add_stripes_stop_at_last_wire_for_area false ;
set_db add_stripes_partial_set_through_domain false ;
set_db add_stripes_ignore_non_default_domains false ;
set_db add_stripes_trim_antenna_back_to_shape none ;
set_db add_stripes_spacing_type edge_to_edge ;
set_db add_stripes_spacing_from_block 0 ;
set_db add_stripes_stripe_min_length stripe_width ;
set_db add_stripes_stacked_via_top_layer Metal6 ;
set_db add_stripes_stacked_via_bottom_layer Metal1 ;
set_db add_stripes_via_using_exact_crossover_size false ;
set_db add_stripes_split_vias false ;
set_db add_stripes_orthogonal_only true ;
set_db add_stripes_allow_jog { padcore_ring block_ring } ;
set_db add_stripes_skip_via_on_pin {  standardcell } ;
set_db add_stripes_skip_via_on_wire_shape {  noshape   }
add_stripes -nets {VDD VSS} -layer Metal6 -direction vertical -width 8 -spacing 1 -set_to_set_distance 100 -start_from left -start_offset 100 -stop_offset 100 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal6 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal6 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) Metal6(6) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal6(6) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) Metal6(6) }
check_floorplan
check_drc
check_place
write_db -sdc $dbs_dir/create_power_grid.db
#@ End verbose source: ../SCRIPTS/create_power_grid.tcl
#@ source ../SCRIPTS/placeopt.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/placeopt.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
read_def $data_dir/def/scan_chain.def
trace_scan
set_multi_cpu_usage -local_cpu 2
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
set_db design_process_node 180
set_db place_global_max_density 0.7
reset_path_group -all
reset_path_group_options
group_path -name input -from [all_inputs -no_clocks] -to [all_registers]
group_path -name output -from [all_registers ] -to [all_outputs ]    
group_path -name in2out -from [all_inputs -no_clocks] -to [all_outputs ]
group_path -name reg2reg -from [filter_collection [all_registers] "is_black_box != true"] -to [filter_collection [all_registers] "is_black_box != true"]
group_path -name reg2mem -from [filter_collection [all_registers] "is_black_box != true"] -to [filter_collection [all_registers] "is_black_box == true"]
group_path -name mem2reg -from [filter_collection [all_registers] "is_black_box == true"] -to [filter_collection [all_registers] "is_black_box != true"]
group_path -name reg2icg -from [filter_collection [all_registers] "is_black_box != true"] -to [filter_collection [all_registers] "is_clock_gating_check == true"]
group_path -name in2icg -from [all_inputs -no_clocks] -to [filter_collection [all_registers] "is_clock_gating_check == true"]
set_path_group_options input -effort_level low
set_path_group_options output -effort_level low
set_path_group_options in2out -effort_level low
set_path_group_options default -effort_level high
set_path_group_options reg2reg -effort_level high
set_path_group_options reg2mem -effort_level high
set_path_group_options mem2reg -effort_level high
set_path_group_options mem2reg -effort_level high
set_path_group_options reg2icg -effort_level high
set_path_group_options in2icg -effort_level low
set_db place_global_timing_effort high
place_opt_design
place_detail -eco true
set_db opt_leakage_to_dynamic_ratio 0.5
set_default_switching_activity -global_activity 0.2 -sequential_activity 0.8
opt_power -pre_cts
set_db add_tieoffs_max_fanout 10
set_db add_tieoffs_max_distance 20
set_db add_tieoffs_cells {TIEHI TIELO}
add_tieoffs
report_congestion -overflow
report_congestion -hotspot
set_db extract_rc_engine pre_route
extract_rc
write_parasitics -spef_file $dbs_dir/place_opt.spef -rc_corner default_rc_corner_worst
time_design -pre_cts -report_prefix place -report_dir $reports_dir
time_design -pre_cts -hold -report_prefix place -report_dir $reports_dir
write_db -sdc $dbs_dir/placeopt.db
#@ End verbose source: ../SCRIPTS/placeopt.tcl
#@ source ../SCRIPTS/cts.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/cts.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
create_route_rule -width {Metal1 0.46 Metal2 0.56 Metal3 0.56 Metal4 0.56 Metal5 0.56 Metal6 0.88} -spacing {Metal1 0.46 Metal2 0.56 Metal3 0.56 Metal4 0.56 Metal5 0.56 Metal6 0.92} -name 2w2s
create_route_type -name clkroute -route_rule 2w2s -bottom_preferred_layer Metal5 -top_preferred_layer Metal6
set_db cts_route_type_trunk clkroute
set_db cts_route_type_leaf clkroute
set_db cts_buffer_cells {CLKBUFX1 CLKBUFX12 CLKBUFX16 CLKBUFX2 CLKBUFX20 CLKBUFX3 CLKBUFX4 CLKBUFX8 CLKBUFXL}
set_db cts_inverter_cells {CLKINVX1 CLKINVX12 CLKINVX16 CLKINVX2 CLKINVX20 CLKINVX3 CLKINVX4 CLKINVX8 CLKINVXL}
set_db cts_use_inverters auto
create_clock_tree_spec -out_file $dbs_dir/ccopt.spec
#@ source $dbs_dir/ccopt.spec
#@ Begin verbose source ../data/dbs/ccopt.spec (pre)
if { [get_db clock_trees] != {} } {...}
namespace eval ::ccopt {}
namespace eval ::ccopt::ilm {}
set ::ccopt::ilm::ccoptSpecRestoreData {}
if { [catch {ccopt_check_and_flatten_ilms_no_restore}] } {...}
set ::ccopt::ilm::ccoptSpecRestoreData $::ccopt::ilm::ccoptRestoreILMState
set_db pin:DTMF_INST/TDSP_DS_CS_INST/i_4380/B1 .cts_sink_type ignore
set_db pin:DTMF_INST/TDSP_DS_CS_INST/i_4380/B1 .cts_sink_type_reasons set_case_analysis
set_db pin:DTMF_INST/TDSP_DS_CS_INST/i_4383/B1 .cts_sink_type ignore
set_db pin:DTMF_INST/TDSP_DS_CS_INST/i_4383/B1 .cts_sink_type_reasons set_case_analysis
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_150/Y .cts_is_sdc_clock_root true
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_152/Y .cts_is_sdc_clock_root true
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_154/Y .cts_is_sdc_clock_root true
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_156/Y .cts_is_sdc_clock_root true
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_158/Y .cts_is_sdc_clock_root true
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_160/Y .cts_is_sdc_clock_root true
create_clock_tree -name vclk2 -source DTMF_INST/TEST_CONTROL_INST/i_152/Y -no_skew_group
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_152/Y .cts_clock_period 14
create_clock_tree -name vclk2<1> -source DTMF_INST/TEST_CONTROL_INST/i_154/Y -no_skew_group
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_154/Y .cts_clock_period 14
create_clock_tree -name vclk2<2> -source DTMF_INST/TEST_CONTROL_INST/i_156/Y -no_skew_group
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_156/Y .cts_clock_period 14
create_clock_tree -name vclk2<3> -source DTMF_INST/TEST_CONTROL_INST/i_158/Y -no_skew_group
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_158/Y .cts_clock_period 14
create_clock_tree -name vclk2<4> -source DTMF_INST/TEST_CONTROL_INST/i_160/Y -no_skew_group
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_160/Y .cts_clock_period 14
create_clock_tree -name vclk1 -source DTMF_INST/TEST_CONTROL_INST/i_150/Y -no_skew_group
set_db pin:DTMF_INST/TEST_CONTROL_INST/i_150/Y .cts_clock_period 7
set_db cts_timing_connectivity_info {}
create_skew_group -name vclk1/default_constraint_mode -sources DTMF_INST/TEST_CONTROL_INST/i_150/Y -auto_sinks
set_db skew_group:vclk1/default_constraint_mode .cts_skew_group_include_source_latency true
set_db skew_group:vclk1/default_constraint_mode .cts_skew_group_created_from_clock vclk1
set_db skew_group:vclk1/default_constraint_mode .cts_skew_group_created_from_constraint_modes {default_constraint_mode  }
set_db skew_group:vclk1/default_constraint_mode .cts_skew_group_created_from_delay_corners {default_delay_corner_max default_delay_corner_min}
create_skew_group -name vclk2/default_constraint_mode -sources {DTMF_INST/TEST_CONTROL_INST/i_152/Y DTMF_INST/TEST_CONTROL_INST/i_154/Y DTMF_INST/TEST_CONTROL_INST/i_156/Y DTMF_INST/TEST_CONTROL_INST/i_158/Y DTMF_INST/TEST_CONTROL_INST/i_160/Y} -auto_sinks
set_db skew_group:vclk2/default_constraint_mode .cts_skew_group_include_source_latency true
set_db skew_group:vclk2/default_constraint_mode .cts_skew_group_created_from_clock vclk2
set_db skew_group:vclk2/default_constraint_mode .cts_skew_group_created_from_constraint_modes {default_constraint_mode  }
set_db skew_group:vclk2/default_constraint_mode .cts_skew_group_created_from_delay_corners {default_delay_corner_max default_delay_corner_min}
check_clock_tree_convergence
if { [get_db ccopt_auto_design_state_for_ilms] == 0 } {...}
#@ End verbose source ../data/dbs/ccopt.spec
set_db cts_target_skew 0.08
set_db cts_target_max_capacitance 0.05
set_db cts_target_max_transition_time 0.04
set_db cts_max_fanout 60
ccopt_design
time_design -post_cts -report_prefix cts -report_dir $reports_dir
time_design -post_cts -hold -report_prefix cts -report_dir $reports_dir
write_db -sdc $dbs_dir/cts.db
#@ End verbose source: ../SCRIPTS/cts.tcl
#@ source ../SCRIPTS/ctsopt.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/ctsopt.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
opt_design -post_cts -report_prefix ctsopt -report_dir $reports_dir
opt_design -post_cts -hold -report_prefix ctsopt -report_dir $reports_dir
opt_design -incremental -post_cts -report_prefix ctsopt_incr -report_dir $reports_dir
opt_design -incremental -post_cts -hold -report_prefix ctsopt_incr -report_dir $reports_dir
report_power
report_congestion -overflow
report_congestion -hotspot
report_clock_trees > $reports_dir/clocktree.rpt
report_skew_groups > $reports_dir/clocktree.skew-group.rpt
write_db -sdc $dbs_dir/ctsopt.db
#@ End verbose source: ../SCRIPTS/ctsopt.tcl
#@ source ../SCRIPTS/route.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/route.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
add_fillers -base_cells FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 -prefix FILLER -check_drc true -check_min_hole true -check_via_enclosure true
set_db route_with_si_driven true
set_db route_with_timing_driven true
route_design -global_detail
time_design -post_route -report_prefix route -report_dir $reports_dir
time_design -hold -post_route -report_prefix route -report_dir $reports_dir
write_db -sdc $dbs_dir/route.db
#@ End verbose source: ../SCRIPTS/route.tcl
#@ source ../SCRIPTS/routeopt.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/routeopt.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
delete_filler -cells FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 -prefix FILLER
set_db route_antenna_diode_insertion true
route_eco
check_drc
check_antenna
check_connectivity
set_db timing_enable_simultaneous_setup_hold_mode true
time_design -post_route
set_db timing_enable_simultaneous_setup_hold_mode false
opt_design -post_route -hold
create_snapshot -name POST_ROUTE
report_metric -file metrics.html -format html
time_design -post_route -report_prefix routeopt -report_dir $reports_dir
time_design -hold -post_route -report_prefix routeopt -report_dir $reports_dir
write_db -sdc $dbs_dir/routeopt.db
#@ End verbose source: ../SCRIPTS/routeopt.tcl
#@ source ../SCRIPTS/chip_finishing.tcl 
#@ Begin verbose source (pre): source ../SCRIPTS/chip_finishing.tcl 
set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"
add_fillers -base_cells FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 -prefix FILLER -check_drc true -check_min_hole true -check_via_enclosure true
report_place_density
add_metal_fill
check_metal_density
time_design -post_route -report_prefix chip_finishing -report_dir $reports_dir
time_design -hold -post_route -report_prefix chip_finishing -report_dir $reports_dir
write_db -sdc $dbs_dir/chip_finishing.db
#@ End verbose source: ../SCRIPTS/chip_finishing.tcl
check_drc
check_antenna
check_connectivity
check_floorplan
check_place
