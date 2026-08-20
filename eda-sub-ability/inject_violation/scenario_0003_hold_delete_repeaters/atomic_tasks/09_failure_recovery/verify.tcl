# Usage: SUBMISSION_TCL=/abs/recovery.tcl innovus -nowin -files verify.tcl
# Apply the known bad ECO, require that it still violates Hold, then run and verify the submitted recovery.

set task_dir [file dirname [file normalize [info script]]]
if {![info exists ::env(SUBMISSION_TCL)] || ![file exists $::env(SUBMISSION_TCL)]} { error "Submission missing" }
source [file join $task_dir initial_state design.enc]
source [file join $task_dir inputs bad_eco.tcl]
set bad_path [get_timing_paths -delay_type min -max_paths 1]
if {$bad_path eq "" || $bad_path eq "0x0"} { error "Bad ECO produced no Hold path" }
set bad_slack [get_property $bad_path slack]
if {$bad_slack >= 0.0} { error "Bad ECO unexpectedly closes Hold: $bad_slack" }
source [file normalize $::env(SUBMISSION_TCL)]

set report_dir [file join $task_dir verifier_reports]
file mkdir $report_dir
proc read_all {path} { set h [open $path r]; set d [read $h]; close $h; return $d }
extractRC
redirect -file [file join $report_dir placement.rpt] { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $report_dir connectivity.rpt]
verify_drc -report [file join $report_dir drc.rpt]
redirect -file [file join $report_dir setup.rpt] { report_timing -late -max_paths 1 -path_type full_clock }
redirect -file [file join $report_dir hold.rpt] { report_timing -early -max_paths 1 -path_type full_clock }
redirect -file [file join $report_dir constraints.rpt] { report_constraint -all_violators }

set placement [read_all [file join $report_dir placement.rpt]]
if {[regexp -nocase {overlap} $placement] || ![regexp {Unplaced\s*=\s*0} $placement]} { error "Placement not clean" }
if {![regexp {Found no problems or warnings} [read_all [file join $report_dir connectivity.rpt]]]} { error "Connectivity not clean" }
if {![regexp {No DRC violations were found} [read_all [file join $report_dir drc.rpt]]]} { error "DRC not clean" }
if {[regexp {VIOLATED} [read_all [file join $report_dir constraints.rpt]]]} { error "DRV not clean" }
regexp {= Slack Time\s+(-?[0-9.]+)} [read_all [file join $report_dir setup.rpt]] unused setup_slack
regexp {Slack Time\s+(-?[0-9.]+)} [read_all [file join $report_dir hold.rpt]] unused hold_slack
if {$setup_slack < 0.0 || $hold_slack < 0.0} { error "Timing not closed" }
set wrong [dbGet -p top.insts.name BAD_HOLD_WRONG_BRANCH]
if {$wrong ne "" && $wrong ne "0x0"} { error "Wrong-branch buffer was not rolled back" }
set recovered [dbGet -p top.insts.name HOLD_FIX_CLKBUF_00140]
if {$recovered eq "" || $recovered eq "0x0" || [dbGet $recovered.cell.name] ne "CLKBUF_X1"} { error "Correct recovery buffer is missing" }
set sink [dbGet -p top.insts.instTerms.name FE_PHC963_00140/A]
if {[dbGet $sink.net.name] ne "HOLD_FIX_CLKBUF_00140_NET"} { error "Recovery did not repair the target branch" }
puts "HOLD_ATOMIC_09_COMPLETE bad=$bad_slack setup=$setup_slack hold=$hold_slack"
exit
