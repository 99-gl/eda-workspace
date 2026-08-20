# Usage: bash scripts/run_validate_golden.sh
# Fresh-load the injected checkpoint, apply the golden repair, verify full closure, and save it.

set scenario_dir [file dirname [file normalize [info script]]]
set input_enc [file join $scenario_dir outputs max_fanout_delete_repeater.enc]
set report_dir [file join $scenario_dir reports repaired]
set output_dir [file join $scenario_dir outputs]
source [file join $scenario_dir scripts common_checks.tcl]

source $input_enc
source [file join $scenario_dir golden_repair.tcl]
collect_checks $report_dir
lassign [require_state $report_dir 0 repaired] setup_slack hold_slack real_count

set repair [dbGet -p top.insts.name FE_OFC611_00305]
set repair_pt [lindex [dbGet $repair.pt] 0]
set metrics [open [file join $report_dir metrics.tsv] w]
puts $metrics "repair_instance\tFE_OFC611_00305"
puts $metrics "repair_master\t[dbGet $repair.cell.name]"
puts $metrics "repair_location\t[join $repair_pt ,]"
puts $metrics "repair_orient\t[dbGet $repair.orient]"
puts $metrics "repair_sink_count\t9"
puts $metrics "real_fanout_violations\t$real_count"
puts $metrics "setup_wns_ns\t$setup_slack"
puts $metrics "hold_wns_ns\t$hold_slack"
close $metrics

set save_path [file join $output_dir golden_repaired.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} { error "Golden repaired checkpoint pair missing" }
puts "MAX_FANOUT_DELETE_REPEATER_GOLDEN_VALIDATION_COMPLETE setup=$setup_slack hold=$hold_slack"
exit

