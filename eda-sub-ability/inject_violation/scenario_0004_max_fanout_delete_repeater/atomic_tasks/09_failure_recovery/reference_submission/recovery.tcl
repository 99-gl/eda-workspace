# Usage: source recovery.tcl
# Roll back the insufficient one-sink ECO and restore the original nine-sink repeater branch.

set bad [dbGet -p top.insts.name BAD_FANOUT_PARTIAL_FIX]
if {$bad ne "" && $bad ne "0x0"} {
    setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
    ecoDeleteRepeater -inst BAD_FANOUT_PARTIAL_FIX
    setEcoMode -batchMode false
}
set sinks [list _19581_/D _13985_/A _13946_/A _13929_/A1 _13913_/A _13812_/A1 _13799_/A1 _13736_/A1 _13704_/A]
setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoAddRepeater -term $sinks -cell BUF_X1 -loc {14.06 59.08} -name FE_OFC611_00305 -newNetName FE_OFN611_00305
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC

