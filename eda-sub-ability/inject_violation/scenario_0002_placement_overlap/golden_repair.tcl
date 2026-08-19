# Usage: source golden_repair.tcl
# Source after loading outputs/placement_overlap.enc in Cadence Innovus 19.10.

set mover_name _14522_
set original_x 32.68
set original_y 119.28
set original_orient R180
set mover [dbGet -p top.insts.name $mover_name]
if {$mover eq "" || $mover eq "0x0" || [dbGet $mover.cell.name] ne "NOR2_X1"} { error "Missing or changed repair target" }
placeInstance $mover_name $original_x $original_y $original_orient
extractRC
set repaired [dbGet -p top.insts.name $mover_name]
if {[lindex [dbGet $repaired.pt] 0] ne [list $original_x $original_y] || [dbGet $repaired.orient] ne $original_orient} {
    error "Golden repair placement postcondition failed"
}
puts "PLACEMENT_OVERLAP_REPAIR_COMPLETE"

