# Usage: source scripts/common_checks.tcl
# Shared report collection and acceptance assertions for scenario_0004.

proc read_all {path} { set h [open $path r]; set d [read $h]; close $h; return $d }
proc count_ptrs {value} { if {$value eq "" || $value eq "0x0"} { return 0 }; return [llength $value] }
proc real_fanout_count {path} {
    set data [read_all $path]
    if {![regexp {\*info: ([0-9]+) violation[s]? is real} $data unused count]} {
        error "Cannot parse real fanout count from $path"
    }
    return $count
}
proc parse_slacks {dir} {
    set setup [read_all [file join $dir setup_worst.rpt]]
    set hold [read_all [file join $dir hold_worst.rpt]]
    if {![regexp {= Slack Time\s+(-?[0-9.]+)} $setup unused setup_slack]} { error "Cannot parse setup slack in $dir" }
    if {![regexp {Slack Time\s+(-?[0-9.]+)} $hold unused hold_slack]} { error "Cannot parse hold slack in $dir" }
    return [list $setup_slack $hold_slack]
}
proc collect_checks {dir} {
    file mkdir $dir
    extractRC
    timeDesign -postRoute -outDir [file join $dir setup]
    timeDesign -postRoute -hold -outDir [file join $dir hold]
    redirect -file [file join $dir setup_worst.rpt] { report_timing -late -max_paths 10 -path_type full_clock }
    redirect -file [file join $dir hold_worst.rpt] { report_timing -early -max_paths 10 -path_type full_clock }
    redirect -file [file join $dir transition.rpt] { reportTranViolation }
    redirect -file [file join $dir capacitance.rpt] { reportCapViolation }
    redirect -file [file join $dir fanout.rpt] { reportFanoutViolation }
    redirect -file [file join $dir constraints.rpt] { report_constraint -all_violators }
    redirect -file [file join $dir placement.rpt] { checkPlace }
    verifyConnectivity -type all -error 1000 -warning 1000 -report [file join $dir connectivity.rpt]
    verify_drc -report [file join $dir drc.rpt]
}
proc require_state {dir expected_real label} {
    set real_count [real_fanout_count [file join $dir fanout.rpt]]
    if {$real_count != $expected_real} { error "$label real fanout count is $real_count, expected $expected_real" }
    if {![regexp {there is 0 max_tran violation} [read_all [file join $dir transition.rpt]]]} { error "$label transition not clean" }
    if {![regexp {there is 0 max_cap violation} [read_all [file join $dir capacitance.rpt]]]} { error "$label capacitance not clean" }
    set placement [read_all [file join $dir placement.rpt]]
    if {[regexp -nocase {overlap} $placement] || ![regexp {Unplaced\s*=\s*0} $placement]} { error "$label placement not clean" }
    if {![regexp {Found no problems or warnings} [read_all [file join $dir connectivity.rpt]]]} { error "$label connectivity not clean" }
    if {![regexp {No DRC violations were found|Total Violations\s*:\s*0} [read_all [file join $dir drc.rpt]]]} { error "$label DRC not clean" }
    lassign [parse_slacks $dir] setup_slack hold_slack
    if {$setup_slack < 0.0 || $hold_slack < 0.0} { error "$label timing not closed: setup=$setup_slack hold=$hold_slack" }
    return [list $setup_slack $hold_slack $real_count]
}

