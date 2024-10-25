set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# add fillers cells
add_fillers -base_cells FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 -prefix FILLER -check_drc true -check_min_hole true -check_via_enclosure true

# running nano route with si and timing
set_db route_with_si_driven true
set_db route_with_timing_driven true

# running nano route
route_design -global_detail

# gernarate timing report
time_design -post_route -report_prefix route -report_dir $reports_dir
time_design -hold -post_route -report_prefix route -report_dir $reports_dir

# save DB
write_db -sdc $dbs_dir/route.db