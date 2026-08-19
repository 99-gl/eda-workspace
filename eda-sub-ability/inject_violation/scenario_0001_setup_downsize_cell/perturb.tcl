# Usage: bash scripts/run_perturb.sh
# The wrapper runs this Tcl and applies the Innovus 19.10 post-exit DB fix.

set scenario_dir [file dirname [file normalize [info script]]]
set eda_root [file normalize [file join $scenario_dir .. ..]]
set baseline_enc [file join $eda_root baseline aes_route.enc]
set output_dir [file join $scenario_dir outputs]
set report_dir [file join $scenario_dir reports]
file mkdir $output_dir
file mkdir [file join $report_dir prepared]
file mkdir [file join $report_dir injected]

set scenario setup_downsize_cell
set targets {
    {_16419_ _07405_ OAI21_X1 OAI21_X4}
    {_16425_ _07411_ OAI221_X1 OAI221_X4}
    {_16427_ _07413_ OAI21_X1 OAI21_X4}
}
set load_locations {
    {32.30 164.08} {36.10 164.08} {39.90 164.08} {43.70 164.08}
    {47.50 164.08} {55.10 164.08} {58.90 164.08} {62.70 164.08}
    {66.50 164.08} {32.30 162.68} {36.10 162.68} {39.90 162.68}
}

source $baseline_enc

# Build a clean loaded fixture with stronger cells, then inject the fault by
# downsizing the three consecutive critical-path cells back to X1.
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach target $targets {
    lassign $target inst_name net_name weak_cell strong_cell
    set inst_ptr [dbGet -p top.insts.name $inst_name]
    if {$inst_ptr eq "" || $inst_ptr eq "0x0"} { error "Missing target $inst_name" }
    if {[dbGet $inst_ptr.cell.name] ne $weak_cell} {
        error "Expected $inst_name to use $weak_cell"
    }
    ecoChangeCell -inst $inst_name -cell $strong_cell
}
setEcoMode -batchMode false

set location_index 0
foreach target $targets {
    lassign $target inst_name net_name weak_cell strong_cell
    for {set index 0} {$index < 4} {incr index} {
        set load_name [format "SETUP_DS_CHAIN_%s_%02d" [string trim $inst_name _] $index]
        addInst -cell BUF_X8 -inst $load_name -loc [lindex $load_locations $location_index] -ori R0 -status placed
        attachTerm $load_name A $net_name
        incr location_index
    }
    catch {editDelete -net $net_name}
}
refinePlace
ecoRoute
extractRC

timeDesign -postRoute -outDir [file join $report_dir prepared setup]
timeDesign -postRoute -hold -outDir [file join $report_dir prepared hold]
redirect -file [file join $report_dir prepared constraints.rpt] {
    report_constraint -all_violators
}

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach target $targets {
    lassign $target inst_name net_name weak_cell strong_cell
    ecoChangeCell -inst $inst_name -cell $weak_cell
}
setEcoMode -batchMode false
ecoRoute
extractRC

timeDesign -postRoute -outDir [file join $report_dir injected setup]
timeDesign -postRoute -hold -outDir [file join $report_dir injected hold]
redirect -file [file join $report_dir injected setup_worst.rpt] {
    report_timing -late -max_paths 10 -path_type full_clock
}
redirect -file [file join $report_dir injected hold_worst.rpt] {
    report_timing -early -max_paths 10 -path_type full_clock
}
redirect -file [file join $report_dir injected constraints.rpt] {
    report_constraint -all_violators
}
redirect -file [file join $report_dir injected fanout.rpt] {
    reportFanoutViolation
}
redirect -file [file join $report_dir injected placement.rpt] { checkPlace }
verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $report_dir injected connectivity.rpt]
verify_drc -report [file join $report_dir injected drc.rpt]

set worst_setup [get_timing_paths -delay_type max -max_paths 1]
if {$worst_setup eq "" || $worst_setup eq "0x0" || [get_property $worst_setup slack] >= 0.0} {
    error "Expected setup violation was not created"
}
foreach target $targets {
    lassign $target inst_name net_name weak_cell strong_cell
    if {[dbGet [dbGet -p top.insts.name $inst_name].cell.name] ne $weak_cell} {
        error "Injected cell postcondition failed for $inst_name"
    }
}

foreach check_file {
    placement.rpt connectivity.rpt drc.rpt
} {
    set check_path [file join $report_dir injected $check_file]
    set handle [open $check_path r]
    set check_data($check_file) [read $handle]
    close $handle
}
if {[regexp {Overlapping with other instance:|Unplaced\s*=\s*[1-9]} $check_data(placement.rpt)]} {
    error "Injected checkpoint has placement violations"
}
if {![regexp {Found no problems or warnings} $check_data(connectivity.rpt)]} {
    error "Injected checkpoint has connectivity violations"
}
if {![regexp {No DRC violations were found|Total Violations\s*:\s*0} $check_data(drc.rpt)]} {
    error "Injected checkpoint has DRC violations"
}

set save_path [file join $output_dir ${scenario}.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} {
    error "Checkpoint pair was not created for $scenario"
}
puts "SETUP_DOWNSIZE_CELL_PERTURB_COMPLETE"
exit
