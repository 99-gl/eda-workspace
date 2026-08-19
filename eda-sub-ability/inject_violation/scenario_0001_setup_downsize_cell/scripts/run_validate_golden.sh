#!/usr/bin/env bash
# Usage: bash scripts/run_validate_golden.sh
# Fresh-load the injected checkpoint, apply the golden repair, and save a clean DB.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
log_dir="${scenario_dir}/logs"
mkdir -p "${log_dir}"

innovus -nowin -files "${scenario_dir}/validate_golden.tcl" > "${log_dir}/validate_golden.log" 2>&1
grep -q 'SETUP_DOWNSIZE_CELL_GOLDEN_VALIDATION_COMPLETE' "${log_dir}/validate_golden.log"

integ_file="${scenario_dir}/outputs/golden_repaired.enc.dat/aes_cipher_top.integ.const"
if [[ -f "${integ_file}" ]] && [[ "$(wc -c < "${integ_file}")" -eq 48 ]] && \
   grep -q '^#Integration constraints ascii out from FE-DB\.$' "${integ_file}"; then
    : > "${integ_file}"
fi

test -s "${scenario_dir}/outputs/golden_repaired.enc"
test -d "${scenario_dir}/outputs/golden_repaired.enc.dat"
echo 'SETUP_DOWNSIZE_CELL_GOLDEN_RUNNER_COMPLETE'
