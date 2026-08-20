# Usage: bash scripts/run_perturb.sh
# Deletes one fanout-tree repeater, updates routing and RC, and saves the injected checkpoint.

set scenario_dir [file dirname [file normalize [info script]]]
set eda_root [file normalize [file join $scenario_dir .. ..]]
set baseline_enc [file join $eda_root baseline aes_route.enc]
set output_dir [file join $scenario_dir outputs]
file mkdir $output_dir

source $baseline_enc

set target_name FE_OFC611_00305
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoDeleteRepeater -inst $target_name
setEcoMode -batchMode false
ecoRoute
extractRC

saveDesign [file join $output_dir max_fanout_delete_repeater.enc]
puts "MAX_FANOUT_DELETE_REPEATER_PERTURB_COMPLETE"
exit
