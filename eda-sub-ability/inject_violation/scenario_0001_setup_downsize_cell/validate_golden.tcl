# Usage: bash scripts/run_validate_golden.sh
# The wrapper fresh-loads the injected DB, runs this Tcl, and fixes the saved DB stub.

set scenario_dir [file dirname [file normalize [info script]]]
set input_enc [file join $scenario_dir outputs setup_downsize_cell.enc]
set report_dir [file join $scenario_dir reports repaired]
set output_dir [file join $scenario_dir outputs]
file mkdir $report_dir

source $input_enc
source [file join $scenario_dir golden_repair.tcl]

timeDesign -postRoute -outDir [file join $report_dir setup]
timeDesign -postRoute -hold -outDir [file join $report_dir hold]
set setup_report [file join $report_dir setup_worst.rpt]
set hold_report [file join $report_dir hold_worst.rpt]
redirect -file $setup_report {
    report_timing -late -max_paths 10 -path_type full_clock
}
redirect -file $hold_report {
    report_timing -early -max_paths 10 -path_type full_clock
}
set constraint_report [file join $report_dir constraints.rpt]
redirect -file $constraint_report { report_constraint -all_violators }
redirect -file [file join $report_dir fanout.rpt] { reportFanoutViolation }
redirect -file [file join $report_dir placement.rpt] { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $report_dir connectivity.rpt]
verify_drc -report [file join $report_dir drc.rpt]

set handle [open $setup_report r]
set setup_data [read $handle]
close $handle
set handle [open $hold_report r]
set hold_data [read $handle]
close $handle
if {![regexp {= Slack Time\s+(-?[0-9.]+)} $setup_data unused setup_slack]} {
    error "Could not parse repaired setup slack"
}
if {![regexp {Slack Time\s+(-?[0-9.]+)} $hold_data unused hold_slack]} {
    error "Could not parse repaired hold slack"
}
if {$setup_slack < 0.0} {
    error "Golden repair leaves a setup violation"
}
if {$hold_slack < 0.0} {
    error "Golden repair leaves a hold violation"
}
set handle [open $constraint_report r]
set constraint_data [read $handle]
close $handle
if {[regexp {VIOLATED} $constraint_data]} {
    error "Golden repair leaves a constraint violation"
}

set save_path [file join $output_dir golden_repaired.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} {
    error "Golden repaired checkpoint pair was not created"
}
puts "SETUP_DOWNSIZE_CELL_GOLDEN_VALIDATION_COMPLETE"
exit
