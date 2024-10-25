set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# delete fillers cells
delete_filler -cells FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 -prefix FILLER

# antenna fixing (insert diode is one of them)
set_db route_antenna_diode_insertion true
route_eco

# check DRC, antenna, connectivity
check_drc
check_antenna
check_connectivity

### check timing
# simulate setup and hold time at the same time
set_db timing_enable_simultaneous_setup_hold_mode true
# preview timing result
time_design -post_route
set_db timing_enable_simultaneous_setup_hold_mode false

# optimize design to meet setup and hold timing
opt_design -post_route -hold

# create metrics
create_snapshot -name POST_ROUTE
report_metric -file metrics.html -format html

# gernarate timing report
time_design -post_route -report_prefix routeopt -report_dir $reports_dir
time_design -hold -post_route -report_prefix routeopt -report_dir $reports_dir

# save DB
write_db -sdc $dbs_dir/routeopt.db