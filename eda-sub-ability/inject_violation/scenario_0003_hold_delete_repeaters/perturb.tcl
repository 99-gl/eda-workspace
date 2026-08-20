# Usage: bash scripts/run_perturb.sh
# Load the untouched AES route baseline, delete two short-path repeaters, validate the Hold violation, and save it.

set scenario_dir [file dirname [file normalize [info script]]]
set eda_root [file normalize [file join $scenario_dir .. ..]]
set baseline_enc [file join $eda_root baseline aes_route.enc]
set output_dir [file join $scenario_dir outputs]
set report_dir [file join $scenario_dir reports]
file mkdir $output_dir
file mkdir [file join $report_dir prepared]
file mkdir [file join $report_dir injected]

proc read_all {path} {
    set handle [open $path r]
    set data [read $handle]
    close $handle
    return $data
}

proc collect_checks {dir} {
    file mkdir $dir
    extractRC
    timeDesign -postRoute -outDir [file join $dir setup]
    timeDesign -postRoute -hold -outDir [file join $dir hold]
    redirect -file [file join $dir setup_worst.rpt] { report_timing -late -max_paths 10 -path_type full_clock }
    redirect -file [file join $dir hold_worst.rpt] { report_timing -early -max_paths 10 -path_type full_clock }
    redirect -file [file join $dir constraints.rpt] { report_constraint -all_violators }
    redirect -file [file join $dir fanout.rpt] { reportFanoutViolation }
    redirect -file [file join $dir placement.rpt] { checkPlace }
    verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $dir connectivity.rpt]
    verify_drc -report [file join $dir drc.rpt]
}

proc require_physical_clean {dir label} {
    set placement [read_all [file join $dir placement.rpt]]
    set connectivity [read_all [file join $dir connectivity.rpt]]
    set drc [read_all [file join $dir drc.rpt]]
    if {[regexp -nocase {overlap} $placement] || ![regexp {Unplaced\s*=\s*0} $placement]} {
        error "$label placement is not clean"
    }
    if {![regexp {Found no problems or warnings} $connectivity]} {
        error "$label connectivity is not clean"
    }
    if {![regexp {No DRC violations were found|Total Violations\s*:\s*0} $drc]} {
        error "$label DRC is not clean"
    }
}

source $baseline_enc

set deleted_repeaters {
    {FE_PHC917_00140 CLKBUF_X1 {47.31 19.88}}
    {FE_PHC1249_00140 BUF_X1 {50.16 25.48}}
}
foreach item $deleted_repeaters {
    lassign $item inst_name master location
    set inst [dbGet -p top.insts.name $inst_name]
    if {$inst eq "" || $inst eq "0x0"} { error "Missing injection target $inst_name" }
    if {[dbGet $inst.cell.name] ne $master || [lindex [dbGet $inst.pt] 0] ne $location} {
        error "Unexpected baseline state for $inst_name"
    }
}

collect_checks [file join $report_dir prepared]
require_physical_clean [file join $report_dir prepared] prepared
set prepared_hold [get_timing_paths -delay_type min -max_paths 1]
if {$prepared_hold eq "" || $prepared_hold eq "0x0" || [get_property $prepared_hold slack] < 0.0} {
    error "Prepared baseline has a Hold violation"
}

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach item $deleted_repeaters {
    lassign $item inst_name master location
    ecoDeleteRepeater -inst $inst_name
}
setEcoMode -batchMode false
ecoRoute
extractRC

foreach item $deleted_repeaters {
    lassign $item inst_name master location
    set inst [dbGet -p top.insts.name $inst_name]
    if {$inst ne "" && $inst ne "0x0"} { error "Repeater deletion failed for $inst_name" }
}
set target_term [dbGet -p top.insts.instTerms.name FE_PHC963_00140/A]
if {$target_term eq "" || $target_term eq "0x0"} { error "Target sink FE_PHC963_00140/A is missing" }
set target_net [dbGet $target_term.net.name]
if {$target_net ne "_00140_"} { error "Expected target net _00140_, got $target_net" }

collect_checks [file join $report_dir injected]
require_physical_clean [file join $report_dir injected] injected
set injected_hold [get_timing_paths -delay_type min -max_paths 1]
if {$injected_hold eq "" || $injected_hold eq "0x0"} { error "No injected Hold path" }
set hold_slack [get_property $injected_hold slack]
set hold_beginpoint [get_object_name [get_property $injected_hold startpoint]]
set hold_endpoint [get_object_name [get_property $injected_hold endpoint]]
set hold_group [get_object_name [get_property $injected_hold path_group]]
if {$hold_slack >= 0.0 || $hold_beginpoint ne "text_in\[23\]" || $hold_endpoint ne "_19212_/D" || $hold_group ne "aes_clk"} {
    error "Expected target Hold violation was not created: $hold_beginpoint $hold_endpoint $hold_slack $hold_group"
}
set injected_setup [get_timing_paths -delay_type max -max_paths 1]
if {$injected_setup eq "" || $injected_setup eq "0x0" || [get_property $injected_setup slack] < 0.0} {
    error "Injection created a Setup violation"
}
if {[regexp {VIOLATED} [read_all [file join $report_dir injected constraints.rpt]]]} {
    error "Injection created an unintended DRV violation"
}

set metadata [open [file join $report_dir injected injection_metadata.tsv] w]
puts $metadata "deleted_instance\tmaster\toriginal_x\toriginal_y"
foreach item $deleted_repeaters {
    lassign $item inst_name master location
    puts $metadata "$inst_name\t$master\t[lindex $location 0]\t[lindex $location 1]"
}
puts $metadata "target_net\t$target_net"
puts $metadata "target_sink\tFE_PHC963_00140/A"
puts $metadata "hold_slack_ns\t$hold_slack"
close $metadata

set save_path [file join $output_dir hold_delete_repeaters.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} { error "Injected checkpoint pair missing" }
puts "HOLD_DELETE_REPEATERS_PERTURB_COMPLETE"
exit
