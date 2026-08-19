# Usage: CHECKPOINT_ENC=/absolute/path/design.enc innovus -nowin -files fresh_load_smoke.tcl
# Verifies that a generated checkpoint restores with DB integrity checks enabled.

if {![info exists ::env(CHECKPOINT_ENC)] || $::env(CHECKPOINT_ENC) eq ""} {
    error "CHECKPOINT_ENC is required"
}
source [file normalize $::env(CHECKPOINT_ENC)]
set design_name [dbGet top.name]
if {$design_name ne "aes_cipher_top"} {
    error "Unexpected restored design $design_name"
}
puts "FRESH_LOAD_SMOKE_COMPLETE $::env(CHECKPOINT_ENC)"
exit
