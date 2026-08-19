#!/usr/bin/env bash
# Usage: bash scripts/run_perturb.sh
# Run from any directory on the Innovus VM; outputs stay inside this scenario.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
log_dir="${scenario_dir}/logs"
mkdir -p "${log_dir}"

innovus -nowin -files "${scenario_dir}/perturb.tcl" > "${log_dir}/perturb.log" 2>&1
grep -q 'SETUP_DOWNSIZE_CELL_PERTURB_COMPLETE' "${log_dir}/perturb.log"

integ_file="${scenario_dir}/outputs/setup_downsize_cell.enc.dat/aes_cipher_top.integ.const"
if [[ -f "${integ_file}" ]] && [[ "$(wc -c < "${integ_file}")" -eq 48 ]] && \
   grep -q '^#Integration constraints ascii out from FE-DB\.$' "${integ_file}"; then
    : > "${integ_file}"
fi

test -s "${scenario_dir}/outputs/setup_downsize_cell.enc"
test -d "${scenario_dir}/outputs/setup_downsize_cell.enc.dat"
echo 'SETUP_DOWNSIZE_CELL_RUNNER_COMPLETE'
