# Usage: bash scripts/run_perturb.sh
# Loads the untouched AES route baseline, records the clean prepared state,
# moves _14522_ onto _14662_, validates the overlap, and saves the checkpoint.

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
    redirect -file [file join $dir placement.rpt] { checkPlace }
    verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $dir connectivity.rpt]
    verify_drc -report [file join $dir drc.rpt]
    timeDesign -postRoute -outDir [file join $dir setup]
    timeDesign -postRoute -hold -outDir [file join $dir hold]
    redirect -file [file join $dir setup_worst.rpt] { report_timing -late -max_paths 10 -path_type full_clock }
    redirect -file [file join $dir hold_worst.rpt] { report_timing -early -max_paths 10 -path_type full_clock }
    redirect -file [file join $dir constraints.rpt] { report_constraint -all_violators }
    redirect -file [file join $dir fanout.rpt] { reportFanoutViolation }
}

source $baseline_enc
collect_checks [file join $report_dir prepared]
set prepared_place [read_all [file join $report_dir prepared placement.rpt]]
if {[regexp -nocase {overlap} $prepared_place] || ![regexp {Unplaced\s*=\s*0} $prepared_place]} { error "Baseline placement is not clean" }
if {![regexp {Found no problems or warnings} [read_all [file join $report_dir prepared connectivity.rpt]]]} { error "Baseline connectivity is not clean" }
if {![regexp {No DRC violations were found|Total Violations\s*:\s*0} [read_all [file join $report_dir prepared drc.rpt]]]} { error "Baseline DRC is not clean" }

set mover_name _14522_
set target_name _14662_
set mover [dbGet -p top.insts.name $mover_name]
set target [dbGet -p top.insts.name $target_name]
foreach ptr [list $mover $target] {
    if {$ptr eq "" || $ptr eq "0x0" || [dbGet $ptr.pStatus] ne "placed" || [dbGet $ptr.cell.baseClass] ne "core" || [dbGet $ptr.cell.subClass] ne "core"} {
        error "Invalid placement-overlap target"
    }
}
set target_pt [lindex [dbGet $target.pt] 0]
lassign $target_pt target_x target_y
placeInstance $mover_name $target_x $target_y R180
if {[lindex [dbGet [dbGet -p top.insts.name $mover_name].pt] 0] ne $target_pt} { error "Mover did not reach target origin" }

collect_checks [file join $report_dir injected]
set placement_data [read_all [file join $report_dir injected placement.rpt]]
if {![regexp {Overlapping with other instance:\s*2} $placement_data] || ![regexp {Unplaced\s*=\s*0} $placement_data]} {
    error "Expected two-object overlap was not created"
}
set overlap_names {}
foreach inst_ptr [dbGet top.insts] {
    if {[lindex [dbGet $inst_ptr.pt] 0] eq $target_pt} { lappend overlap_names [dbGet $inst_ptr.name] }
}
set overlap_names [lsort $overlap_names]
if {$overlap_names ne [lsort [list $mover_name $target_name]]} { error "Unexpected overlap objects: $overlap_names" }
set objects [open [file join $report_dir injected overlap_objects.tsv] w]
puts $objects "target_origin\t$target_x\t$target_y"
foreach name $overlap_names { puts $objects "instance\t$name" }
close $objects

set save_path [file join $output_dir placement_overlap.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} { error "Injected checkpoint pair missing" }
puts "PLACEMENT_OVERLAP_PERTURB_COMPLETE"
exit

