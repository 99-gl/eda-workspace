#!/usr/bin/env bash
# Usage: bash scripts/run_perturb.sh
# Run the formal max-fanout injection and apply only the exact Innovus 19.10 integration-stub workaround.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
mkdir -p "${scenario_dir}/logs"
innovus -nowin -files "${scenario_dir}/perturb.tcl" </dev/null > "${scenario_dir}/logs/perturb.log" 2>&1
grep -q 'MAX_FANOUT_DELETE_REPEATER_PERTURB_COMPLETE' "${scenario_dir}/logs/perturb.log"
integ_file="${scenario_dir}/outputs/max_fanout_delete_repeater.enc.dat/aes_cipher_top.integ.const"
if [[ -f "${integ_file}" ]] && [[ "$(wc -c < "${integ_file}")" -eq 48 ]] && grep -qx '#Integration constraints ascii out from FE-DB\.' "${integ_file}"; then
    : > "${integ_file}"
fi
test -s "${scenario_dir}/outputs/max_fanout_delete_repeater.enc"
test -d "${scenario_dir}/outputs/max_fanout_delete_repeater.enc.dat"
echo MAX_FANOUT_DELETE_REPEATER_PERTURB_RUNNER_COMPLETE

