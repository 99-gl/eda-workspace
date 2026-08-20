# Usage: bash scripts/run_perturb.sh
# Builds the loaded fixture, downsizes the three target cells, and saves the injected checkpoint.

set scenario_dir [file dirname [file normalize [info script]]]
set eda_root [file normalize [file join $scenario_dir .. ..]]
set baseline_enc [file join $eda_root baseline aes_route.enc]
set output_dir [file join $scenario_dir outputs]
file mkdir $output_dir

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

# Build the loaded X4 fixture used by this scenario.
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach target $targets {
    lassign $target inst_name net_name weak_cell strong_cell
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

# Inject the setup violation by downsizing the three consecutive path cells.
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach target $targets {
    lassign $target inst_name net_name weak_cell strong_cell
    ecoChangeCell -inst $inst_name -cell $weak_cell
}
setEcoMode -batchMode false
ecoRoute
extractRC

saveDesign [file join $output_dir setup_downsize_cell.enc]
puts "SETUP_DOWNSIZE_CELL_PERTURB_COMPLETE"
exit
