# Usage: source inputs/bad_eco.tcl
# Apply an intentionally insufficient one-sink buffer ECO.

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoAddRepeater -term [list _19581_/D] -cell BUF_X1 -loc {14.06 59.08} -name BAD_FANOUT_PARTIAL_FIX -newNetName BAD_FANOUT_PARTIAL_NET
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC

