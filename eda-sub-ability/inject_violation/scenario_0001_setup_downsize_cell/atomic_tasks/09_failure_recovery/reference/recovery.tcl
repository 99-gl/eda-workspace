# Usage: source reference/recovery.tcl

set targets {{_16419_ OAI21_X1 OAI21_X4} {_16425_ OAI221_X1 OAI221_X4} {_16427_ OAI21_X1 OAI21_X4}}
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach target $targets {
    lassign $target inst_name weak_cell strong_cell
    set inst_ptr [dbGet -p top.insts.name $inst_name]
    set current_cell [dbGet $inst_ptr.cell.name]
    if {$current_cell eq $strong_cell} { continue }
    if {$current_cell ne $weak_cell} { error "Unexpected state $current_cell for $inst_name" }
    ecoChangeCell -inst $inst_name -cell $strong_cell
}
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC
