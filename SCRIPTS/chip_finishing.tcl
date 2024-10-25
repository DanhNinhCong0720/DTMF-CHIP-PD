set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# add fillers cells
add_fillers -base_cells FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 -prefix FILLER -check_drc true -check_min_hole true -check_via_enclosure true
report_place_density

# add metal fill
add_metal_fill
check_metal_density

# gernarate timing report
time_design -post_route -report_prefix chip_finishing -report_dir $reports_dir
time_design -hold -post_route -report_prefix chip_finishing -report_dir $reports_dir

# save DB
write_db -sdc $dbs_dir/chip_finishing.db