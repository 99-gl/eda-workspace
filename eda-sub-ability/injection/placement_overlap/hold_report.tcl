# Usage (guest): innovus -nowin -files hold_report.tcl
set scenario placement_overlap
set script_dir [file dirname [file normalize [info script]]]
source [file join $script_dir ${scenario}.enc]
extractRC
redirect -file [file join $script_dir hold.rpt] { report_timing -early -max_paths 1 -path_type full_clock }
set paths [get_timing_paths -delay_type min -max_paths 1]
if {$paths eq "" || $paths eq "0x0"} { error "No hold timing path found" }
set beginpoint [get_object_name [get_property $paths startpoint]]
set endpoint [get_object_name [get_property $paths endpoint]]
set slack [get_property $paths slack]
set path_group [get_object_name [get_property $paths path_group]]
set fh [open [file join $script_dir hold.json] w]
puts $fh "{\"scenario\":\"$scenario\",\"analysis\":\"hold\",\"worst_path\":\"$beginpoint -> $endpoint\",\"beginpoint\":\"$beginpoint\",\"endpoint\":\"$endpoint\",\"slack_ns\":$slack,\"path_group\":\"$path_group\"}"
close $fh
exit
