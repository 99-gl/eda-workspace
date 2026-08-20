# Usage: innovus -nowin -files characterize_side_effects.tcl
# Measure area, power, congestion, and timing before and after the golden repair.

set scenario_dir [file dirname [file normalize [info script]]]
set report_root [file join $scenario_dir reports side_effects]
file mkdir [file join $report_root injected]
file mkdir [file join $report_root repaired]

proc capture_state {dir} {
    file mkdir $dir
    extractRC
    redirect -file [file join $dir area.rpt] { reportGateCount -level 5 -outfile [file join $dir gate_count.rpt] }
    set power_status [catch { redirect -file [file join $dir power.rpt] { report_power } } power_error]
    set congestion_status [catch { redirect -file [file join $dir congestion.rpt] { reportCongestion -overflow } } congestion_error]
    redirect -file [file join $dir setup_worst.rpt] { report_timing -late -max_paths 1 -path_type full_clock }
    redirect -file [file join $dir hold_worst.rpt] { report_timing -early -max_paths 1 -path_type full_clock }
    set handle [open [file join $dir command_status.tsv] w]
    puts $handle "power\t$power_status\t$power_error"
    puts $handle "congestion\t$congestion_status\t$congestion_error"
    close $handle
}

source [file join $scenario_dir outputs hold_delete_repeaters.enc]
capture_state [file join $report_root injected]
source [file join $scenario_dir golden_repair.tcl]
capture_state [file join $report_root repaired]
puts HOLD_DELETE_REPEATERS_SIDE_EFFECTS_COMPLETE
exit
