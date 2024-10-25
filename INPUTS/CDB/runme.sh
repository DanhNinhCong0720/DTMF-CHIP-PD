#!/bin/bash
#===============================================================================
#
#          FILE:  runme.sh
# 
#         USAGE:  ./runme.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Jiri Hladky (JH), hladky@cadence.com
#       COMPANY:  Cadence Design Systems
#       VERSION:  1.0
#       CREATED:  03/17/2009 03:42:19 PM CET
#      REVISION:  ---
#===============================================================================
make_cdb report_fast.tcl | tee report_fast.log
make_cdb report_slow.tcl | tee report_slow.log
make_cdb report_typical.tcl | tee report_typical.log


