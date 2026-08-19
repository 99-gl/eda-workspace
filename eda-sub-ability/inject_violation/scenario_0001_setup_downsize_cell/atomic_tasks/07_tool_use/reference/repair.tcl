# Usage: source reference/repair.tcl

set targets {{_16419_ OAI21_X1 OAI21_X4} {_16425_ OAI221_X1 OAI221_X4} {_16427_ OAI21_X1 OAI21_X4}}
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach target $targets {
    lassign $target inst_name weak_cell strong_cell
    set inst_ptr [dbGet -p top.insts.name $inst_name]
    if {[dbGet $inst_ptr.cell.name] ne $weak_cell} { error "Unexpected starting cell for $inst_name" }
    ecoChangeCell -inst $inst_name -cell $strong_cell
}
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC
