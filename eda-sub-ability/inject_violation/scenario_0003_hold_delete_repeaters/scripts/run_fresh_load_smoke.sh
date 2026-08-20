#!/usr/bin/env bash
# Usage: bash scripts/run_fresh_load_smoke.sh
# Fresh-load both formal checkpoints and require their distinct Hold-state markers.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"

CHECKPOINT_ENC="${scenario_dir}/outputs/hold_delete_repeaters.enc" EXPECT_HOLD_VIOLATION=yes \
    innovus -nowin -files "${script_dir}/fresh_load_smoke.tcl" > "${scenario_dir}/logs/smoke_injected.log" 2>&1
grep -q 'HOLD_DELETE_REPEATERS_FRESH_LOAD_COMPLETE yes' "${scenario_dir}/logs/smoke_injected.log"

CHECKPOINT_ENC="${scenario_dir}/outputs/golden_repaired.enc" EXPECT_HOLD_VIOLATION=no \
    innovus -nowin -files "${script_dir}/fresh_load_smoke.tcl" > "${scenario_dir}/logs/smoke_golden.log" 2>&1
grep -q 'HOLD_DELETE_REPEATERS_FRESH_LOAD_COMPLETE no' "${scenario_dir}/logs/smoke_golden.log"
echo HOLD_DELETE_REPEATERS_SMOKE_RUNNER_COMPLETE
