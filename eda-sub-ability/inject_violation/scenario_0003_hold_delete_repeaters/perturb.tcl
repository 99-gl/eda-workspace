# Usage: bash scripts/run_perturb.sh
# Deletes two short-path repeaters, updates routing and RC, and saves the injected checkpoint.

set scenario_dir [file dirname [file normalize [info script]]]
set eda_root [file normalize [file join $scenario_dir .. ..]]
set baseline_enc [file join $eda_root baseline aes_route.enc]
set output_dir [file join $scenario_dir outputs]
file mkdir $output_dir

source $baseline_enc

set deleted_repeaters {FE_PHC917_00140 FE_PHC1249_00140}
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach inst_name $deleted_repeaters {
    ecoDeleteRepeater -inst $inst_name
}
setEcoMode -batchMode false
ecoRoute
extractRC

saveDesign [file join $output_dir hold_delete_repeaters.enc]
puts "HOLD_DELETE_REPEATERS_PERTURB_COMPLETE"
exit
