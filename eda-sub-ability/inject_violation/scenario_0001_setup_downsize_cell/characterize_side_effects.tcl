# Usage: innovus -nowin -files characterize_side_effects.tcl
# Compare measurable global effects before and after the golden repair.

set scenario_dir [file dirname [file normalize [info script]]]
set report_root [file join $scenario_dir reports side_effects]
file mkdir [file join $report_root injected]
file mkdir [file join $report_root repaired]

source [file join $scenario_dir outputs setup_downsize_cell.enc]
redirect -file [file join $report_root injected check_design.rpt] { checkDesign -all }
set injected_power_status [catch {
    redirect -file [file join $report_root injected power.rpt] { report_power }
} injected_power_error]
set injected_congestion_status [catch {
    redirect -file [file join $report_root injected congestion.rpt] { reportCongestion -overflow }
} injected_congestion_error]

source [file join $scenario_dir golden_repair.tcl]
redirect -file [file join $report_root repaired check_design.rpt] { checkDesign -all }
set repaired_power_status [catch {
    redirect -file [file join $report_root repaired power.rpt] { report_power }
} repaired_power_error]
set repaired_congestion_status [catch {
    redirect -file [file join $report_root repaired congestion.rpt] { reportCongestion -overflow }
} repaired_congestion_error]

set status_handle [open [file join $report_root status.tsv] w]
puts $status_handle "metric\tinjected_status\trepaired_status\tinjected_error\trepaired_error"
puts $status_handle "power\t$injected_power_status\t$repaired_power_status\t$injected_power_error\t$repaired_power_error"
puts $status_handle "congestion\t$injected_congestion_status\t$repaired_congestion_status\t$injected_congestion_error\t$repaired_congestion_error"
close $status_handle

puts "SETUP_DOWNSIZE_CELL_SIDE_EFFECTS_COMPLETE"
exit
