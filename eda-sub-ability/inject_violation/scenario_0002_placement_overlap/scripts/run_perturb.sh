#!/usr/bin/env bash
# Usage: bash scripts/run_perturb.sh
# Runs the formal injection and handles the Innovus 19.10 48-byte integrity stub.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
mkdir -p "${scenario_dir}/logs"
innovus -nowin -files "${scenario_dir}/perturb.tcl" > "${scenario_dir}/logs/perturb.log" 2>&1
grep -q 'PLACEMENT_OVERLAP_PERTURB_COMPLETE' "${scenario_dir}/logs/perturb.log"
integ_file="${scenario_dir}/outputs/placement_overlap.enc.dat/aes_cipher_top.integ.const"
if [[ -f "${integ_file}" ]] && [[ "$(wc -c < "${integ_file}")" -eq 48 ]] && grep -q '^#Integration constraints ascii out from FE-DB\.$' "${integ_file}"; then
  : > "${integ_file}"
fi
test -s "${scenario_dir}/outputs/placement_overlap.enc"
test -d "${scenario_dir}/outputs/placement_overlap.enc.dat"
echo PLACEMENT_OVERLAP_PERTURB_RUNNER_COMPLETE

