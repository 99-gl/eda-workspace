# Usage: bash scripts/run_validate_golden.sh
# Fresh-load the injected checkpoint, apply one local buffer repair, verify closure, and save the repaired checkpoint.

set scenario_dir [file dirname [file normalize [info script]]]
set input_enc [file join $scenario_dir outputs hold_delete_repeaters.enc]
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
source [file join $scenario_dir golden_repair.tcl]

timeDesign -postRoute -outDir [file join $report_dir setup]
timeDesign -postRoute -hold -outDir [file join $report_dir hold]
redirect -file [file join $report_dir setup_worst.rpt] { report_timing -late -max_paths 10 -path_type full_clock }
redirect -file [file join $report_dir hold_worst.rpt] { report_timing -early -max_paths 10 -path_type full_clock }
redirect -file [file join $report_dir constraints.rpt] { report_constraint -all_violators }
redirect -file [file join $report_dir fanout.rpt] { reportFanoutViolation }
redirect -file [file join $report_dir placement.rpt] { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $report_dir connectivity.rpt]
verify_drc -report [file join $report_dir drc.rpt]

set hold_path [get_timing_paths -delay_type min -max_paths 1]
if {$hold_path eq "" || $hold_path eq "0x0"} { error "No repaired Hold path" }
set hold_slack [get_property $hold_path slack]
set hold_beginpoint [get_object_name [get_property $hold_path startpoint]]
set hold_endpoint [get_object_name [get_property $hold_path endpoint]]
if {$hold_slack < 0.0} { error "Golden repair leaves a Hold violation: $hold_slack" }
set setup_path [get_timing_paths -delay_type max -max_paths 1]
if {$setup_path eq "" || $setup_path eq "0x0"} { error "No repaired Setup path" }
set setup_slack [get_property $setup_path slack]
if {$setup_slack < 0.0} { error "Golden repair leaves a Setup violation: $setup_slack" }

set constraint_data [read_all [file join $report_dir constraints.rpt]]
set placement_data [read_all [file join $report_dir placement.rpt]]
set connectivity_data [read_all [file join $report_dir connectivity.rpt]]
set drc_data [read_all [file join $report_dir drc.rpt]]
if {[regexp {VIOLATED} $constraint_data]} { error "Golden repair leaves a DRV violation" }
if {[regexp -nocase {overlap} $placement_data] || ![regexp {Unplaced\s*=\s*0} $placement_data]} { error "Golden repair placement is not clean" }
if {![regexp {Found no problems or warnings} $connectivity_data]} { error "Golden repair connectivity is not clean" }
if {![regexp {No DRC violations were found|Total Violations\s*:\s*0} $drc_data]} { error "Golden repair DRC is not clean" }

set metrics [open [file join $report_dir metrics.tsv] w]
puts $metrics "hold_slack_ns\t$hold_slack"
puts $metrics "hold_beginpoint\t$hold_beginpoint"
puts $metrics "hold_endpoint\t$hold_endpoint"
puts $metrics "setup_slack_ns\t$setup_slack"
puts $metrics "repair_instance\tHOLD_FIX_CLKBUF_00140"
puts $metrics "repair_cell\tCLKBUF_X1"
puts $metrics "repair_sink\tFE_PHC963_00140/A"
close $metrics

set save_path [file join $output_dir golden_repaired.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} { error "Golden repaired checkpoint pair missing" }
puts "HOLD_DELETE_REPEATERS_GOLDEN_VALIDATION_COMPLETE"
exit
