# Usage: SUBMISSION_TCL=/abs/recovery.tcl innovus -nowin -files verify.tcl
# Apply the known ineffective ECO, require the violation to remain, then validate submitted recovery.

set task_dir [file dirname [file normalize [info script]]]
if {![info exists ::env(SUBMISSION_TCL)] || ![file exists $::env(SUBMISSION_TCL)]} { error "Submission missing" }
source [file join $task_dir initial_state design.enc]
source [file join $task_dir inputs bad_eco.tcl]
set report_dir [file join $task_dir verifier_reports]
file mkdir $report_dir
proc read_all {path} { set h [open $path r]; set d [read $h]; close $h; return $d }
redirect -file [file join $report_dir bad_fanout.rpt] { reportFanoutViolation }
if {![regexp {1 violation is real} [read_all [file join $report_dir bad_fanout.rpt]]]} { error "Bad ECO unexpectedly closed fanout" }
set bad [dbGet -p top.insts.name BAD_FANOUT_PARTIAL_FIX]
if {$bad eq "" || $bad eq "0x0"} { error "Bad ECO object missing" }

source [file normalize $::env(SUBMISSION_TCL)]
extractRC
redirect -file [file join $report_dir fanout.rpt] { reportFanoutViolation }
redirect -file [file join $report_dir transition.rpt] { reportTranViolation }
redirect -file [file join $report_dir capacitance.rpt] { reportCapViolation }
redirect -file [file join $report_dir setup.rpt] { report_timing -late -max_paths 1 -path_type full_clock }
redirect -file [file join $report_dir hold.rpt] { report_timing -early -max_paths 1 -path_type full_clock }
redirect -file [file join $report_dir placement.rpt] { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $report_dir connectivity.rpt]
verify_drc -report [file join $report_dir drc.rpt]

if {![regexp {0 violation is real} [read_all [file join $report_dir fanout.rpt]]]} { error "Recovery leaves fanout violation" }
if {![regexp {there is 0 max_tran violation} [read_all [file join $report_dir transition.rpt]]]} { error "Recovery leaves transition violation" }
if {![regexp {there is 0 max_cap violation} [read_all [file join $report_dir capacitance.rpt]]]} { error "Recovery leaves capacitance violation" }
set placement [read_all [file join $report_dir placement.rpt]]
if {[regexp -nocase {overlap} $placement] || ![regexp {Unplaced\s*=\s*0} $placement]} { error "Recovery placement not clean" }
if {![regexp {Found no problems or warnings} [read_all [file join $report_dir connectivity.rpt]]]} { error "Recovery connectivity not clean" }
if {![regexp {No DRC violations were found|Total Violations\s*:\s*0} [read_all [file join $report_dir drc.rpt]]]} { error "Recovery DRC not clean" }
if {![regexp {= Slack Time\s+(-?[0-9.]+)} [read_all [file join $report_dir setup.rpt]] unused setup_slack] || $setup_slack < 0.0} { error "Recovery setup not closed" }
if {![regexp {Slack Time\s+(-?[0-9.]+)} [read_all [file join $report_dir hold.rpt]] unused hold_slack] || $hold_slack < 0.0} { error "Recovery hold not closed" }
set bad [dbGet -p top.insts.name BAD_FANOUT_PARTIAL_FIX]
if {$bad ne "" && $bad ne "0x0"} { error "Bad ECO was not rolled back" }
set repair [dbGet -p top.insts.name FE_OFC611_00305]
if {$repair eq "" || $repair eq "0x0" || [dbGet $repair.cell.name] ne "BUF_X1"} { error "Correct recovery repeater missing" }
foreach sink_name {_19581_/D _13985_/A _13946_/A _13929_/A1 _13913_/A _13812_/A1 _13799_/A1 _13736_/A1 _13704_/A} {
    set sink [dbGet -p top.insts.instTerms.name $sink_name]
    if {[dbGet $sink.net.name] ne "FE_OFN611_00305"} { error "Recovery branch mismatch for $sink_name" }
}
puts "MAX_FANOUT_ATOMIC_09_COMPLETE setup=$setup_slack hold=$hold_slack"
exit

