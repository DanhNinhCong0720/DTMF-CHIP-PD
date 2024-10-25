set data_dir "../INPUTS"
set reports_dir "./reports"
set dbs_dir "../data/dbs"

# connecting global nets
connect_global_net VDD -type pgpin -pin VDD -all
connect_global_net VSS -type pgpin -pin VSS -all
connect_global_net VDD -type tiehi
connect_global_net VSS -type tielo

set_layer_preference pinObj -is_visible 1

# add a ring around the core 
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

# add a ring around the DTMF_INST/PLLCLK_INST block
select_obj [get_db insts *DTMF_INST/PLLCLK_INST]
add_rings -nets {VDD VSS} -type block_rings -around selected -layer {top Metal5 bottom Metal5 left Metal6 right Metal6} -width {top 8 bottom 8 left 8 right 8} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1 bottom 1 left 1 right 1} -center 0 -extend_corners {bl lb} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
gui_deselect -all

# add PG stripes
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

# add special route
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) Metal6(6) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal6(6) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) Metal6(6) }

# check floorplan, drc, place
check_floorplan
check_drc
check_place
check_connectivity

# save DB
write_db -sdc $dbs_dir/create_power_grid.db