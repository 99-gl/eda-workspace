# Usage: source inputs/bad_eco.tcl

set inst_ptr [dbGet -p top.insts.name _16419_]
if {[dbGet $inst_ptr.cell.name] ne "OAI21_X1"} { error "Unexpected initial state for _16419_" }
ecoChangeCell -inst _16419_ -cell OAI21_X4
refinePlace
ecoRoute
extractRC
puts "BAD_ECO_PARTIAL_REPAIR_COMPLETE"
