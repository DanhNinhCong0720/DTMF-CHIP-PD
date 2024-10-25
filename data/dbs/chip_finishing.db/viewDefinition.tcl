if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name default_libset_max\
   -timing\
    [list ${::IMEX::libVar}/mmmc/rom_512x16A_slow_syn.lib\
    ${::IMEX::libVar}/mmmc/tpz973gwc-lite_slow.lib\
    ${::IMEX::libVar}/mmmc/ram_256x16A_slow_syn.lib\
    ${::IMEX::libVar}/mmmc/ram_128x16A_slow_syn.lib\
    ${::IMEX::libVar}/mmmc/slow.lib\
    ${::IMEX::libVar}/mmmc/pllclk_slow.lib]\
   -si\
    [list ${::IMEX::libVar}/mmmc/slow.cdb]
create_library_set -name default_libset_min\
   -timing\
    [list ${::IMEX::libVar}/mmmc/ram_256x16A_fast_syn.lib\
    ${::IMEX::libVar}/mmmc/pllclk_fast.lib\
    ${::IMEX::libVar}/mmmc/ram_128x16A_fast_syn.lib\
    ${::IMEX::libVar}/mmmc/fast.lib\
    ${::IMEX::libVar}/mmmc/rom_512x16A_fast_syn.lib\
    ${::IMEX::libVar}/mmmc/tpz973gbc-lite_fast.lib]\
   -si\
    [list ${::IMEX::libVar}/mmmc/fast.cdb]
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
   -qrc_tech ${::IMEX::libVar}/mmmc/default_rc_corner_worst/t018s6mm.tch
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
    [list ${::IMEX::dataVar}/mmmc/modes/default_constraint_mode/default_constraint_mode.sdc]
create_analysis_view -name default_analysis_view_setup -constraint_mode default_constraint_mode -delay_corner default_delay_corner_max -latency_file ${::IMEX::dataVar}/mmmc/views/default_analysis_view_setup/latency.sdc
create_analysis_view -name default_analysis_view_hold -constraint_mode default_constraint_mode -delay_corner default_delay_corner_min -latency_file ${::IMEX::dataVar}/mmmc/views/default_analysis_view_hold/latency.sdc
set_analysis_view -setup [list default_analysis_view_setup] -hold [list default_analysis_view_hold]
