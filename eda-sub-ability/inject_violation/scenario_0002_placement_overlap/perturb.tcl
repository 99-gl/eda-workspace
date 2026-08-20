# Usage: bash scripts/run_perturb.sh
# Moves one placed cell onto another cell and saves the injected checkpoint.

set scenario_dir [file dirname [file normalize [info script]]]
set eda_root [file normalize [file join $scenario_dir .. ..]]
set baseline_enc [file join $eda_root baseline aes_route.enc]
set output_dir [file join $scenario_dir outputs]
file mkdir $output_dir

source $baseline_enc

set mover_name _14522_
set target [dbGet -p top.insts.name _14662_]
set target_pt [lindex [dbGet $target.pt] 0]
placeInstance $mover_name [lindex $target_pt 0] [lindex $target_pt 1] R180

saveDesign [file join $output_dir placement_overlap.enc]
puts "PLACEMENT_OVERLAP_PERTURB_COMPLETE"
exit
