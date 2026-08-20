#!/usr/bin/env bash
# Usage: bash scripts/run_fresh_load_smoke.sh
# Fresh-load both formal checkpoints and require markers plus generated evidence reports.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
mkdir -p "${scenario_dir}/logs" "${scenario_dir}/reports/fresh_load/injected" "${scenario_dir}/reports/fresh_load/repaired"
CHECKPOINT_ENC="${scenario_dir}/outputs/max_fanout_delete_repeater.enc" EXPECT_REAL_FANOUT=1 STATE=injected REPORT_DIR="${scenario_dir}/reports/fresh_load/injected" \
    innovus -nowin -files "${script_dir}/fresh_load_smoke.tcl" </dev/null > "${scenario_dir}/logs/smoke_injected.log" 2>&1
grep -q 'MAX_FANOUT_DELETE_REPEATER_FRESH_LOAD_COMPLETE state=injected real=1' "${scenario_dir}/logs/smoke_injected.log"
grep -q '_00305_' "${scenario_dir}/reports/fresh_load/injected/fanout.rpt"
CHECKPOINT_ENC="${scenario_dir}/outputs/golden_repaired.enc" EXPECT_REAL_FANOUT=0 STATE=repaired REPORT_DIR="${scenario_dir}/reports/fresh_load/repaired" \
    innovus -nowin -files "${script_dir}/fresh_load_smoke.tcl" </dev/null > "${scenario_dir}/logs/smoke_repaired.log" 2>&1
grep -q 'MAX_FANOUT_DELETE_REPEATER_FRESH_LOAD_COMPLETE state=repaired real=0' "${scenario_dir}/logs/smoke_repaired.log"
grep -q '0 violation is real' "${scenario_dir}/reports/fresh_load/repaired/fanout.rpt"
echo MAX_FANOUT_DELETE_REPEATER_SMOKE_RUNNER_COMPLETE

