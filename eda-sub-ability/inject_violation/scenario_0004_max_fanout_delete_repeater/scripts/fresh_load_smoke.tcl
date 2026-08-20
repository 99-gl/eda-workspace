# Usage: CHECKPOINT_ENC=<abs.enc> EXPECT_REAL_FANOUT=0|1 STATE=injected|repaired REPORT_DIR=<dir> innovus -nowin -files fresh_load_smoke.tcl
# Fresh-load one formal checkpoint and independently prove its object, DRV, timing, and physical state.

foreach required {CHECKPOINT_ENC EXPECT_REAL_FANOUT STATE REPORT_DIR} {
    if {![info exists ::env($required)] || $::env($required) eq ""} { error "$required is required" }
}
set script_dir [file dirname [file normalize [info script]]]
source [file join $script_dir common_checks.tcl]
source [file normalize $::env(CHECKPOINT_ENC)]
if {[dbGet top.name] ne "aes_cipher_top"} { error "Unexpected fresh-load design" }
set report_dir [file normalize $::env(REPORT_DIR)]
collect_checks $report_dir
lassign [require_state $report_dir $::env(EXPECT_REAL_FANOUT) fresh_load] setup_slack hold_slack real_count
set target [dbGet -p top.insts.name FE_OFC611_00305]
if {$::env(STATE) eq "injected"} {
    if {$target ne "" && $target ne "0x0"} { error "Injected fresh-load contains deleted repeater" }
    set fanout [read_all [file join $report_dir fanout.rpt]]
    if {[string first _00305_ $fanout] < 0 || [string first _13365_/ZN $fanout] < 0} { error "Injected fresh-load fanout object proof failed" }
} elseif {$::env(STATE) eq "repaired"} {
    if {$target eq "" || $target eq "0x0" || [dbGet $target.cell.name] ne "BUF_X1"} { error "Repaired fresh-load target missing" }
} else {
    error "STATE must be injected or repaired"
}
puts "MAX_FANOUT_DELETE_REPEATER_FRESH_LOAD_COMPLETE state=$::env(STATE) real=$real_count setup=$setup_slack hold=$hold_slack"
exit

