# Usage: bash scripts/run_perturb.sh
# Fresh-load the untouched AES routed baseline, delete one data repeater, prove one real max-fanout violation, and save it.

set scenario_dir [file dirname [file normalize [info script]]]
set eda_root [file normalize [file join $scenario_dir .. ..]]
set baseline_enc [file join $eda_root baseline aes_route.enc]
set output_dir [file join $scenario_dir outputs]
set report_root [file join $scenario_dir reports]
file mkdir $output_dir
source [file join $scenario_dir scripts common_checks.tcl]

set target_name FE_OFC611_00305
set target_master BUF_X1
set target_location {14.06 59.08}
set target_orient R0
set input_net_name _00305_
set output_net_name FE_OFN611_00305
set driver_term_name _13365_/ZN
set driver_master INV_X1
set target_sinks {
    _19581_/D _13985_/A _13946_/A _13929_/A1 _13913_/A
    _13812_/A1 _13799_/A1 _13736_/A1 _13704_/A
}

if {![file exists $baseline_enc] || ![file isdirectory ${baseline_enc}.dat]} { error "Untouched baseline pair missing" }
source $baseline_enc
if {[dbGet top.name] ne "aes_cipher_top"} { error "Unexpected baseline design" }

set inst [dbGet -p top.insts.name $target_name]
if {$inst eq "" || $inst eq "0x0"} { error "Missing target $target_name" }
if {[dbGet $inst.cell.name] ne $target_master || [lindex [dbGet $inst.pt] 0] ne $target_location || [dbGet $inst.orient] ne $target_orient} {
    error "Target baseline master/location/orientation mismatch"
}
set input_term [lindex [dbGet $inst.instTerms.isInput 1 -p] 0]
set output_term [lindex [dbGet $inst.instTerms.isOutput 1 -p] 0]
if {[dbGet $input_term.net.name] ne $input_net_name || [dbGet $output_term.net.name] ne $output_net_name} { error "Target baseline nets mismatch" }
set driver_term [dbGet -p top.insts.instTerms.name $driver_term_name]
if {$driver_term eq "" || $driver_term eq "0x0" || [dbGet $driver_term.net.name] ne $input_net_name || [dbGet $driver_term.inst.cell.name] ne $driver_master} {
    error "Target upstream driver mismatch"
}
foreach sink_name $target_sinks {
    set sink [dbGet -p top.insts.instTerms.name $sink_name]
    if {$sink eq "" || $sink eq "0x0" || [dbGet $sink.net.name] ne $output_net_name} { error "Baseline sink mismatch for $sink_name" }
}

collect_checks [file join $report_root prepared]
lassign [require_state [file join $report_root prepared] 0 prepared] prepared_setup prepared_hold unused

setEcoMode -batchMode true -refinePlace false -updateTiming false -honorFixedNetWire false
ecoDeleteRepeater -inst $target_name
setEcoMode -batchMode false
ecoRoute
extractRC

set deleted [dbGet -p top.insts.name $target_name]
if {$deleted ne "" && $deleted ne "0x0"} { error "Repeater deletion failed" }
set merged_net [dbGet -p top.nets.name $input_net_name]
if {$merged_net eq "" || $merged_net eq "0x0"} { error "Merged net missing" }
set merged_fanout [count_ptrs [dbGet $merged_net.instTerms.isInput 1 -p]]
if {$merged_fanout != 17} { error "Merged fanout is $merged_fanout, expected 17" }
foreach sink_name $target_sinks {
    set sink [dbGet -p top.insts.instTerms.name $sink_name]
    if {[dbGet $sink.net.name] ne $input_net_name} { error "Injected sink did not merge for $sink_name" }
}

collect_checks [file join $report_root injected]
lassign [require_state [file join $report_root injected] 1 injected] injected_setup injected_hold real_count
set fanout_data [read_all [file join $report_root injected fanout.rpt]]
if {[string first $input_net_name $fanout_data] < 0 || [string first $driver_term_name $fanout_data] < 0} {
    error "Fanout report does not identify the intended net and driver"
}

set metadata [open [file join $report_root injected injection_metadata.tsv] w]
puts $metadata "deleted_instance\t$target_name"
puts $metadata "master\t$target_master"
puts $metadata "original_location\t[join $target_location ,]"
puts $metadata "original_orient\t$target_orient"
puts $metadata "driver_term\t$driver_term_name"
puts $metadata "driver_master\t$driver_master"
puts $metadata "merged_net\t$input_net_name"
puts $metadata "original_output_net\t$output_net_name"
puts $metadata "original_sink_count\t[llength $target_sinks]"
puts $metadata "original_sinks\t[join $target_sinks ,]"
puts $metadata "merged_fanout\t$merged_fanout"
puts $metadata "real_fanout_violations\t$real_count"
puts $metadata "prepared_setup_wns_ns\t$prepared_setup"
puts $metadata "prepared_hold_wns_ns\t$prepared_hold"
puts $metadata "injected_setup_wns_ns\t$injected_setup"
puts $metadata "injected_hold_wns_ns\t$injected_hold"
close $metadata

set save_path [file join $output_dir max_fanout_delete_repeater.enc]
saveDesign $save_path
if {![file exists $save_path] || ![file isdirectory ${save_path}.dat]} { error "Injected checkpoint pair missing" }
puts "MAX_FANOUT_DELETE_REPEATER_PERTURB_COMPLETE target=$target_name fanout=$merged_fanout setup=$injected_setup hold=$injected_hold"
exit

