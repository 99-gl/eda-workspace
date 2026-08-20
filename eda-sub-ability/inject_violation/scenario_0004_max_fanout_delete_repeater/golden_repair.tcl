# Usage: source golden_repair.tcl
# Source after loading outputs/max_fanout_delete_repeater.enc to restore the deleted branch repeater.

set repair_name FE_OFC611_00305
set repair_cell BUF_X1
set repair_location {14.06 59.08}
set repair_input_net _00305_
set repair_output_net FE_OFN611_00305
set repair_sinks [list _19581_/D _13985_/A _13946_/A _13929_/A1 _13913_/A _13812_/A1 _13799_/A1 _13736_/A1 _13704_/A]

set existing [dbGet -p top.insts.name $repair_name]
if {$existing ne "" && $existing ne "0x0"} { error "Injected state unexpectedly contains $repair_name" }
foreach sink_name $repair_sinks {
    set sink [dbGet -p top.insts.instTerms.name $sink_name]
    if {$sink eq "" || $sink eq "0x0" || [dbGet $sink.net.name] ne $repair_input_net} { error "Injected repair sink mismatch for $sink_name" }
}

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoAddRepeater -term $repair_sinks -cell $repair_cell -loc $repair_location -name $repair_name -newNetName $repair_output_net
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC

set repaired [dbGet -p top.insts.name $repair_name]
if {$repaired eq "" || $repaired eq "0x0" || [dbGet $repaired.cell.name] ne $repair_cell} { error "Golden repair instance postcondition failed" }
foreach sink_name $repair_sinks {
    set sink [dbGet -p top.insts.instTerms.name $sink_name]
    if {[dbGet $sink.net.name] ne $repair_output_net} { error "Golden repair branch mismatch for $sink_name" }
}
puts "MAX_FANOUT_DELETE_REPEATER_REPAIR_COMPLETE"
