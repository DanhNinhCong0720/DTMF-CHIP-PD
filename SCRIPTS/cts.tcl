set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# create CTS non default rule (NDR) to use for clock net routing
create_route_rule -width {Metal1 0.46 Metal2 0.56 Metal3 0.56 Metal4 0.56 Metal5 0.56 Metal6 0.88} -spacing {Metal1 0.46 Metal2 0.56 Metal3 0.56 Metal4 0.56 Metal5 0.56 Metal6 0.92} -name 2w2s

# create a route type to define the NDR and layers to use for routing the clock tree
create_route_type -name clkroute -route_rule 2w2s -bottom_preferred_layer Metal5 -top_preferred_layer Metal6

# specify that this route type should be used for trunk and leaf nets:
set_db cts_route_type_trunk clkroute
set_db cts_route_type_leaf clkroute

# specify CTS clock buffers and inverters
set_db cts_buffer_cells {CLKBUFX1 CLKBUFX12 CLKBUFX16 CLKBUFX2 CLKBUFX20 CLKBUFX3 CLKBUFX4 CLKBUFX8 CLKBUFXL}
set_db cts_inverter_cells {CLKINVX1 CLKINVX12 CLKINVX16 CLKINVX2 CLKINVX20 CLKINVX3 CLKINVX4 CLKINVX8 CLKINVXL}

### CTS engine buffer/inverter preference setting.
# default is auto (prefer buffers but also use inverters where needed).
# set to "true" to use inverters only
set_db cts_use_inverters auto

# generate the ccopt spec file and source it:
create_clock_tree_spec -out_file $dbs_dir/ccopt.spec
source $dbs_dir/ccopt.spec

# set CTS skew target
set_db cts_target_skew 0.08

# set cts drv rules
set_db cts_target_max_capacitance 0.05
set_db cts_target_max_transition_time 0.04
set_db cts_max_fanout 60

# build clock tree and optimize data path (setup and hold) concurrently and preroute all clock nets
ccopt_design

# save timing report
time_design -post_cts -report_prefix cts -report_dir $reports_dir
time_design -post_cts -hold -report_prefix cts -report_dir $reports_dir

# save DB 
write_db -sdc $dbs_dir/cts.db