# Usage: source golden_repair.tcl
# Source after loading outputs/hold_delete_repeaters.enc in Cadence Innovus 19.10.

set repair_name HOLD_FIX_CLKBUF_00140
set repair_net HOLD_FIX_CLKBUF_00140_NET
set repair_cell CLKBUF_X1
set repair_term FE_PHC963_00140/A
set repair_location {47.31 19.88}

foreach deleted_name {FE_PHC917_00140 FE_PHC1249_00140} {
    set deleted [dbGet -p top.insts.name $deleted_name]
    if {$deleted ne "" && $deleted ne "0x0"} { error "Injected state unexpectedly contains $deleted_name" }
}
set existing [dbGet -p top.insts.name $repair_name]
if {$existing ne "" && $existing ne "0x0"} { error "Repair instance already exists" }
set sink [dbGet -p top.insts.instTerms.name $repair_term]
if {$sink eq "" || $sink eq "0x0" || [dbGet $sink.net.name] ne "_00140_"} {
    error "Repair sink is missing or not on _00140_"
}

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoAddRepeater -term [list $repair_term] -cell $repair_cell -loc $repair_location -name $repair_name -newNetName $repair_net
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC

set repair [dbGet -p top.insts.name $repair_name]
if {$repair eq "" || $repair eq "0x0" || [dbGet $repair.cell.name] ne $repair_cell} {
    error "Golden repair instance postcondition failed"
}
set repaired_sink [dbGet -p top.insts.instTerms.name $repair_term]
if {[dbGet $repaired_sink.net.name] ne $repair_net} { error "Golden repair sink split failed" }
puts "HOLD_DELETE_REPEATERS_REPAIR_COMPLETE"
