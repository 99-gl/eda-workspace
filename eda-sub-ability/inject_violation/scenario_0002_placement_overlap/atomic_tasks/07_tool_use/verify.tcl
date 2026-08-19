# Usage: SUBMISSION_TCL=/abs/repair.tcl innovus -nowin -files verify.tcl

set task_dir [file dirname [file normalize [info script]]]
if {![info exists ::env(SUBMISSION_TCL)] || ![file exists $::env(SUBMISSION_TCL)]} { error "Submission missing" }
source [file join $task_dir initial_state design.enc]
source [file normalize $::env(SUBMISSION_TCL)]
set report_dir [file join $task_dir verifier_reports]
file mkdir $report_dir
proc read_all {path} { set h [open $path r]; set d [read $h]; close $h; return $d }
redirect -file [file join $report_dir placement.rpt] { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $report_dir connectivity.rpt]
verify_drc -report [file join $report_dir drc.rpt]
timeDesign -postRoute -outDir [file join $report_dir setup]
timeDesign -postRoute -hold -outDir [file join $report_dir hold]
redirect -file [file join $report_dir setup.rpt] { report_timing -late -max_paths 1 -path_type full_clock }
redirect -file [file join $report_dir hold.rpt] { report_timing -early -max_paths 1 -path_type full_clock }
redirect -file [file join $report_dir constraints.rpt] { report_constraint -all_violators }
set p [read_all [file join $report_dir placement.rpt]]
if {[regexp -nocase {overlap} $p] || ![regexp {Unplaced\s*=\s*0} $p]} { error "Placement not clean" }
if {![regexp {Found no problems or warnings} [read_all [file join $report_dir connectivity.rpt]]]} { error "Connectivity not clean" }
if {![regexp {No DRC violations were found} [read_all [file join $report_dir drc.rpt]]]} { error "DRC not clean" }
if {[regexp {VIOLATED} [read_all [file join $report_dir constraints.rpt]]]} { error "DRV not clean" }
regexp {= Slack Time\s+(-?[0-9.]+)} [read_all [file join $report_dir setup.rpt]] unused setup_slack
regexp {Slack Time\s+(-?[0-9.]+)} [read_all [file join $report_dir hold.rpt]] unused hold_slack
if {$setup_slack < 0.0 || $hold_slack < 0.0} { error "Timing not closed" }
set mover [dbGet -p top.insts.name _14522_]
set anchor [dbGet -p top.insts.name _14662_]
if {[lindex [dbGet $mover.pt] 0] ne {32.68 119.28} || [dbGet $mover.orient] ne "R180"} { error "Mover wrong" }
if {[lindex [dbGet $anchor.pt] 0] ne {33.25 119.28} || [dbGet $anchor.orient] ne "MX"} { error "Anchor changed" }
puts "PLACEMENT_ATOMIC_07_COMPLETE setup=$setup_slack hold=$hold_slack"
exit

