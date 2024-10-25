set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# load scan def
read_def $data_dir/def/scan_chain.def
trace_scan

# enable multi-threading
set_multi_cpu_usage -local_cpu 2

# set analysis type
set_db timing_analysis_type ocv

# enable cppr removal for both setup and hold
set_db timing_analysis_cppr both

# set process node (this impact cap setting for rc extraction)
set_db design_process_node 180

# set placement maximum density
set_db place_global_max_density 0.7

# set group path
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

# set optimizing effort per path group
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

# set congestion driven (placement strategy)
set_db place_global_timing_effort high
#set_db place_global_cong_effort high
#set_db place_global_activity_power_effort high
#set_db place_global_clock_power_driven true

# run placement
place_opt_design

# run detail placement
place_detail -eco true

# power opt
set_db opt_leakage_to_dynamic_ratio 0.5
set_default_switching_activity -global_activity 0.2 -sequential_activity 0.8
opt_power -pre_cts

# add tiecells
set_db add_tieoffs_max_fanout 10
set_db add_tieoffs_max_distance 20
set_db add_tieoffs_cells {TIEHI TIELO}
add_tieoffs

# report congetsion
report_congestion -overflow
report_congestion -hotspot

# extract rc
set_db extract_rc_engine pre_route
extract_rc
write_parasitics -spef_file $dbs_dir/place_opt.spef -rc_corner default_rc_corner_worst

# save timing report
time_design -pre_cts -report_prefix place -report_dir $reports_dir
time_design -pre_cts -hold -report_prefix place -report_dir $reports_dir

# save DB
write_db -sdc $dbs_dir/placeopt.db