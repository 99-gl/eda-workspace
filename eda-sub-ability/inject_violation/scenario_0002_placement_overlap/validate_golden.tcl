# Usage: bash scripts/run_validate_golden.sh
# Fresh-loads the injected checkpoint, applies the golden repair, validates all
# acceptance checks, and saves outputs/golden_repaired.enc.

set scenario_dir [file dirname [file normalize [info script]]]
set input_enc [file join $scenario_dir outputs placement_overlap.enc]
set report_dir [file join $scenario_dir reports repaired]
set output_dir [file join $scenario_dir outputs]
file mkdir $report_dir
proc read_all {path} {
    set handle [open $path r]
    set data [read $handle]
    close $handle
    return $data
}

source $input_enc
redirect -file [file join $report_dir fresh_load_injected_placement.rpt] { checkPlace }
if {![regexp {Overlapping with other instance:\s*2} [read_all [file join $report_dir fresh_load_injected_placement.rpt]]]} {
    error "Fresh-loaded injected checkpoint lost the overlap"
}
source [file join $scenario_dir golden_repair.tcl]

set placement_report [file join $report_dir placement.rpt]
set connectivity_report [file join $report_dir connectivity.rpt]
set drc_report [file join $report_dir drc.rpt]
set setup_report [file join $report_dir setup_worst.rpt]
set hold_report [file join $report_dir hold_worst.rpt]
set constraint_report [file join $report_dir constraints.rpt]
redirect -file $placement_report { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report $connectivity_report
verify_drc -report $drc_report
timeDesign -postRoute -outDir [file join $report_dir setup]
timeDesign -postRoute -hold -outDir [file join $report_dir hold]
redirect -file $setup_report { report_timing -late -max_paths 10 -path_type full_clock }
redirect -file $hold_report { report_timing -early -max_paths 10 -path_type full_clock }
redirect -file $constraint_report { report_constraint -all_violators }
redirect -file [file join $report_dir fanout.rpt] { reportFanoutViolation }

set placement_data [read_all $placement_report]
if {[regexp -nocase {overlap} $placement_data] || ![regexp {Unplaced\s*=\s*0} $placement_data]} { error "Golden placement is not clean" }
if {![regexp {Found no problems or warnings} [read_all $connectivity_report]]} { error "Golden connectivity is not clean" }
if {![regexp {No DRC violations were found|Total Violations\s*:\s*0} [read_all $drc_report]]} { error "Golden DRC is not clean" }
if {[regexp {VIOLATED} [read_all $constraint_report]]} { error "Golden DRV constraints are not clean" }
if {![regexp {= Slack Time\s+(-?[0-9.]+)} [read_all $setup_report] unused setup_slack]} { error "Cannot parse setup slack" }
if {![regexp {Slack Time\s+(-?[0-9.]+)} [read_all $hold_report] unused hold_slack]} { error "Cannot parse hold slack" }
if {$setup_slack < 0.0 || $hold_slack < 0.0} { error "Golden timing is not closed" }

set save_path [file join $output_dir golden_repaired.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} { error "Golden checkpoint pair missing" }
puts "PLACEMENT_OVERLAP_GOLDEN_VALIDATION_COMPLETE setup=$setup_slack hold=$hold_slack"
exit

