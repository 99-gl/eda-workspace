# Usage: source inputs/bad_eco.tcl
# Insert a buffer on an unrelated Setup branch; the target Hold path remains unmodified.

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoAddRepeater -term [list _19318_/D] -cell BUF_X1 -loc {47.31 19.88} -name BAD_HOLD_WRONG_BRANCH -newNetName BAD_HOLD_WRONG_BRANCH_NET
setEcoMode -batchMode false
refinePlace
ecoRoute
extractRC
puts BAD_HOLD_ECO_COMPLETE
