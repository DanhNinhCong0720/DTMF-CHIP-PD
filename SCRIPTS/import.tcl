set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# specify the names for the power and ground nets
set_db init_power_nets VDD
set_db init_ground_nets VSS

# read MMMC file (timing model and constraints)
read_mmmc $data_dir/mmmc/dtmf.mmmc

# read LEF abstracts and P&R technology file
read_physical -lef {../INPUTS/lef/all.lef}

# load netlist file
read_netlist $data_dir/verilog/dtmf_chip_ak.v

# init design
init_design

# read io file
read_io_file $data_dir/fp/dtmf.io

# specify FP size
create_floorplan -site tsm3site -core_size 842 842 100 100 100 100

# fit screen
gui_fit

# save FP db
write_db -sdc $dbs_dir/import.db