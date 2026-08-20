# Usage: CHECKPOINT_ENC=/abs/design.enc EXPECT_HOLD_VIOLATION=yes innovus -nowin -files fresh_load_smoke.tcl
# Restore one generated checkpoint with integrity checks enabled and verify its Hold state.

foreach required {CHECKPOINT_ENC EXPECT_HOLD_VIOLATION} {
    if {![info exists ::env($required)] || $::env($required) eq ""} { error "$required is required" }
}
source [file normalize $::env(CHECKPOINT_ENC)]
if {[dbGet top.name] ne "aes_cipher_top"} { error "Unexpected restored design" }
extractRC
set path [get_timing_paths -delay_type min -max_paths 1]
if {$path eq "" || $path eq "0x0"} { error "No Hold path after fresh load" }
set slack [get_property $path slack]
set repair [dbGet -p top.insts.name HOLD_FIX_CLKBUF_00140]
if {$::env(EXPECT_HOLD_VIOLATION) eq "yes"} {
    if {$slack >= 0.0} { error "Expected Hold violation missing after fresh load: $slack" }
    if {$repair ne "" && $repair ne "0x0"} { error "Injected checkpoint unexpectedly contains repair instance" }
} else {
    if {$slack < 0.0} { error "Repaired checkpoint still violates Hold: $slack" }
    if {$repair eq "" || $repair eq "0x0" || [dbGet $repair.cell.name] ne "CLKBUF_X1"} { error "Repair instance missing after fresh load" }
}
puts "HOLD_DELETE_REPEATERS_FRESH_LOAD_COMPLETE $::env(EXPECT_HOLD_VIOLATION) $slack"
exit
