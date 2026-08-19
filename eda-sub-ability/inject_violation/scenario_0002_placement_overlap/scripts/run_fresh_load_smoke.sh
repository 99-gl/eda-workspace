#!/usr/bin/env bash
# Usage: bash scripts/run_fresh_load_smoke.sh
# Fresh-loads both formal checkpoints and requires distinct success markers.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
CHECKPOINT_ENC="${scenario_dir}/outputs/placement_overlap.enc" EXPECT_OVERLAP=yes innovus -nowin -files "${script_dir}/fresh_load_smoke.tcl" > "${scenario_dir}/logs/smoke_injected.log" 2>&1
grep -q 'PLACEMENT_OVERLAP_FRESH_LOAD_COMPLETE yes' "${scenario_dir}/logs/smoke_injected.log"
CHECKPOINT_ENC="${scenario_dir}/outputs/golden_repaired.enc" EXPECT_OVERLAP=no innovus -nowin -files "${script_dir}/fresh_load_smoke.tcl" > "${scenario_dir}/logs/smoke_golden.log" 2>&1
grep -q 'PLACEMENT_OVERLAP_FRESH_LOAD_COMPLETE no' "${scenario_dir}/logs/smoke_golden.log"
echo PLACEMENT_OVERLAP_SMOKE_RUNNER_COMPLETE

