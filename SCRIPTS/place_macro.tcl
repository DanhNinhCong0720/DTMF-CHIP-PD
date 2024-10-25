set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# place blocks
create_relative_floorplan -place DTMF_INST/PLLCLK_INST -ref_type core_boundary -horizontal_edge_separate {3 20 3} -vertical_edge_separate {0 20 0} 
create_relative_floorplan -place DTMF_INST/RAM_256x16_TEST_INST/RAM_256x16_INST -ref_type core_boundary -horizontal_edge_separate {0 3 0} -vertical_edge_separate {2 -37 2} -orient R270
create_relative_floorplan -place DTMF_INST/RAM_128x16_TEST_INST/RAM_128x16_INST -ref_type core_boundary -horizontal_edge_separate {2 -37 2} -vertical_edge_separate {3 -37 3}
create_relative_floorplan -place DTMF_INST/ARB_INST/ROM_512x16_0_INST -ref_type core_boundary -horizontal_edge_separate {1 -45 1} -vertical_edge_separate {0 3 0} -orient R90

# placing halo around blocks
create_place_halo -halo_deltas {20 20 20 20} -all_blocks

# save DB
write_db -sdc $dbs_dir/place_macro.db