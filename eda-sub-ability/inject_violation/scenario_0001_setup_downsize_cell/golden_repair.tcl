# Usage: source golden_repair.tcl
# Source after loading outputs/setup_downsize_cell.enc in Cadence Innovus 19.10.

set targets {
    {_16419_ OAI21_X1 OAI21_X4}
    {_16425_ OAI221_X1 OAI221_X4}
    {_16427_ OAI21_X1 OAI21_X4}
}

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
foreach target $targets {
    lassign $target inst_name weak_cell strong_cell
    set inst_ptr [dbGet -p top.insts.name $inst_name]
    if {$inst_ptr eq "" || $inst_ptr eq "0x0"} { error "Missing repair target $inst_name" }
    if {[dbGet $inst_ptr.cell.name] ne $weak_cell} {
        error "Expected $inst_name to use $weak_cell before repair"
    }
    ecoChangeCell -inst $inst_name -cell $strong_cell
}
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC

foreach target $targets {
    lassign $target inst_name weak_cell strong_cell
    if {[dbGet [dbGet -p top.insts.name $inst_name].cell.name] ne $strong_cell} {
        error "Repair cell postcondition failed for $inst_name"
    }
}
puts "SETUP_DOWNSIZE_CELL_REPAIR_COMPLETE"
