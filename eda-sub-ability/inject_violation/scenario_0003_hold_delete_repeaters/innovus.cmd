#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Aug 20 22:53:12 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v19.10-p002_1 (64bit) 04/19/2019 15:18 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 19.10-p002_1 NR190418-1643/19_10-UB (database version 18.20, 458.7.1) {superthreading v1.51}
#@(#)CDS: AAE 19.10-b002 (64bit) 04/19/2019 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 19.10-p002_1 () Apr 19 2019 06:39:48 ( )
#@(#)CDS: SYNTECH 19.10-b001_1 () Apr  4 2019 03:00:51 ( )
#@(#)CDS: CPE v19.10-p002
#@(#)CDS: IQuantus/TQuantus 19.1.0-e101 (64bit) Thu Feb 28 10:29:46 PST 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
is_common_ui_mode
restoreDesign /home/host/hold_delete_repeaters_20260820/baseline/aes_route.enc.dat aes_cipher_top
extractRC
timeDesign -postRoute -outDir /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/setup
timeDesign -postRoute -hold -outDir /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/hold
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/setup_worst.rpt { report_timing -late -max_paths 10 -path_type full_clock }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/hold_worst.rpt { report_timing -early -max_paths 10 -path_type full_clock }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/constraints.rpt { report_constraint -all_violators }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/fanout.rpt { reportFanoutViolation }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/placement.rpt { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/connectivity.rpt
verify_drc -report /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/prepared/drc.rpt
report_timing -collection -early -max_points 1
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoDeleteRepeater -inst FE_PHC917_00140
ecoDeleteRepeater -inst FE_PHC1249_00140
setEcoMode -batchMode false
ecoRoute
extractRC
extractRC
timeDesign -postRoute -outDir /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/setup
timeDesign -postRoute -hold -outDir /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/hold
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/setup_worst.rpt { report_timing -late -max_paths 10 -path_type full_clock }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/hold_worst.rpt { report_timing -early -max_paths 10 -path_type full_clock }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/constraints.rpt { report_constraint -all_violators }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/fanout.rpt { reportFanoutViolation }
redirect -file /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/placement.rpt { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/connectivity.rpt
verify_drc -report /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/reports/injected/drc.rpt
report_timing -collection -early -max_points 1
report_timing -collection -late -max_points 1
saveDesign /home/host/hold_delete_repeaters_20260820/inject_violation/scenario_0003_hold_delete_repeaters/outputs/hold_delete_repeaters.enc
