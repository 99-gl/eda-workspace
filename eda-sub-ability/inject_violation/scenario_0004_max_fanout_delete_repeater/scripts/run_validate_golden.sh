#!/usr/bin/env bash
# Usage: bash scripts/run_validate_golden.sh
# Fresh-load the injected checkpoint, apply the golden repair, and save a clean checkpoint.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
mkdir -p "${scenario_dir}/logs"
innovus -nowin -files "${scenario_dir}/validate_golden.tcl" </dev/null > "${scenario_dir}/logs/validate_golden.log" 2>&1
grep -q 'MAX_FANOUT_DELETE_REPEATER_GOLDEN_VALIDATION_COMPLETE' "${scenario_dir}/logs/validate_golden.log"
integ_file="${scenario_dir}/outputs/golden_repaired.enc.dat/aes_cipher_top.integ.const"
if [[ -f "${integ_file}" ]] && [[ "$(wc -c < "${integ_file}")" -eq 48 ]] && grep -qx '#Integration constraints ascii out from FE-DB\.' "${integ_file}"; then
    : > "${integ_file}"
fi
test -s "${scenario_dir}/outputs/golden_repaired.enc"
test -d "${scenario_dir}/outputs/golden_repaired.enc.dat"
echo MAX_FANOUT_DELETE_REPEATER_GOLDEN_RUNNER_COMPLETE

