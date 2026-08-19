#!/usr/bin/env bash
# Usage: bash scripts/run_all.sh
# Runs formal injection, fresh-load repair validation, and checkpoint smoke tests.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "${script_dir}/run_perturb.sh"
bash "${script_dir}/run_validate_golden.sh"
bash "${script_dir}/run_fresh_load_smoke.sh"
echo PLACEMENT_OVERLAP_FULL_FLOW_COMPLETE
