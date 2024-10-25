set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# run postCTS setup and hold optimization
opt_design -post_cts -report_prefix ctsopt -report_dir $reports_dir
opt_design -post_cts -hold -report_prefix ctsopt -report_dir $reports_dir

# run incremental setup and hold fix
opt_design -incremental -post_cts -report_prefix ctsopt_incr -report_dir $reports_dir
opt_design -incremental -post_cts -hold -report_prefix ctsopt_incr -report_dir $reports_dir

# report power and congestion numbers
report_power
report_congestion -overflow
report_congestion -hotspot

# review CTS results and clock tree
report_clock_trees > $reports_dir/clocktree.rpt
report_skew_groups > $reports_dir/clocktree.skew-group.rpt

# write DB
write_db -sdc $dbs_dir/ctsopt.db