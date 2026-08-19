# Usage: CHECKPOINT_ENC=/abs/design.enc EXPECT_OVERLAP=yes innovus -nowin -files fresh_load_smoke.tcl
# Restores a checkpoint with integrity checking enabled and verifies placement state.

foreach required {CHECKPOINT_ENC EXPECT_OVERLAP} {
    if {![info exists ::env($required)] || $::env($required) eq ""} { error "$required is required" }
}
source [file normalize $::env(CHECKPOINT_ENC)]
set report [file join [file dirname [file normalize [info script]]] smoke_placement.rpt]
redirect -file $report { checkPlace }
set handle [open $report r]
set data [read $handle]
close $handle
if {$::env(EXPECT_OVERLAP) eq "yes"} {
    if {![regexp {Overlapping with other instance:\s*2} $data]} { error "Expected overlap missing after fresh load" }
} else {
    if {[regexp -nocase {overlap} $data] || ![regexp {Unplaced\s*=\s*0} $data]} { error "Repaired placement is not clean after fresh load" }
}
puts "PLACEMENT_OVERLAP_FRESH_LOAD_COMPLETE $::env(EXPECT_OVERLAP)"
exit

