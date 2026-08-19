# Usage: SUBMISSION_TCL=/absolute/path/repair.tcl innovus -nowin -files verify.tcl

set task_dir [file dirname [file normalize [info script]]]
if {![info exists ::env(SUBMISSION_TCL)]} { error "SUBMISSION_TCL is not set" }
set submission [file normalize $::env(SUBMISSION_TCL)]
if {![file exists $submission]} { error "Submission does not exist: $submission" }

source [file join $task_dir initial_state design.enc]
source $submission

set report_dir [file join $task_dir verifier_reports]
file mkdir $report_dir
set setup_report [file join $report_dir setup.rpt]
set hold_report [file join $report_dir hold.rpt]
set constraint_report [file join $report_dir constraints.rpt]
set placement_report [file join $report_dir placement.rpt]
set connectivity_report [file join $report_dir connectivity.rpt]
set drc_report [file join $report_dir drc.rpt]

timeDesign -postRoute -outDir [file join $report_dir setup]
timeDesign -postRoute -hold -outDir [file join $report_dir hold]
redirect -file $setup_report { report_timing -late -max_paths 1 -path_type full_clock }
redirect -file $hold_report { report_timing -early -max_paths 1 -path_type full_clock }
redirect -file $constraint_report { report_constraint -all_violators }
redirect -file $placement_report { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report $connectivity_report
verify_drc -report $drc_report

proc read_all {path} {
    set handle [open $path r]
    set data [read $handle]
    close $handle
    return $data
}
set setup_data [read_all $setup_report]
set hold_data [read_all $hold_report]
if {![regexp {= Slack Time\s+(-?[0-9.]+)} $setup_data unused setup_slack]} { error "Cannot parse setup slack" }
if {![regexp {Slack Time\s+(-?[0-9.]+)} $hold_data unused hold_slack]} { error "Cannot parse hold slack" }
if {$setup_slack < 0.0 || $hold_slack < 0.0} { error "Timing is not closed: setup=$setup_slack hold=$hold_slack" }
if {[regexp {VIOLATED} [read_all $constraint_report]]} { error "Constraint violations remain" }
if {![regexp {Unplaced = 0} [read_all $placement_report]]} { error "Placement is not clean" }
if {![regexp {Found no problems or warnings} [read_all $connectivity_report]]} { error "Connectivity is not clean" }
if {![regexp {No DRC violations were found} [read_all $drc_report]]} { error "DRC is not clean" }

foreach target {{_16419_ OAI21_X4} {_16425_ OAI221_X4} {_16427_ OAI21_X4}} {
    lassign $target inst_name expected_cell
    set inst_ptr [dbGet -p top.insts.name $inst_name]
    if {$inst_ptr eq "" || $inst_ptr eq "0x0"} { error "Missing target $inst_name" }
    if {[dbGet $inst_ptr.cell.name] ne $expected_cell} { error "$inst_name has the wrong cell" }
}

puts "ATOMIC_07_PASS setup=$setup_slack hold=$hold_slack"
exit
