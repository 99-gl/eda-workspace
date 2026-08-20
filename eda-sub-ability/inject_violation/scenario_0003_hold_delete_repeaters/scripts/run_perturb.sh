#!/usr/bin/env bash
# Usage: bash scripts/run_perturb.sh
# Run the formal Hold injection and normalize the Innovus 19.10 integration stub if present.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scenario_dir="$(cd "${script_dir}/.." && pwd)"
mkdir -p "${scenario_dir}/logs"

innovus -nowin -files "${scenario_dir}/perturb.tcl" > "${scenario_dir}/logs/perturb.log" 2>&1
grep -q 'HOLD_DELETE_REPEATERS_PERTURB_COMPLETE' "${scenario_dir}/logs/perturb.log"

integ_file="${scenario_dir}/outputs/hold_delete_repeaters.enc.dat/aes_cipher_top.integ.const"
if [[ -f "${integ_file}" ]] && [[ "$(wc -c < "${integ_file}")" -eq 48 ]] && \
   grep -q '^#Integration constraints ascii out from FE-DB\.$' "${integ_file}"; then
    : > "${integ_file}"
fi

test -s "${scenario_dir}/outputs/hold_delete_repeaters.enc"
test -d "${scenario_dir}/outputs/hold_delete_repeaters.enc.dat"
echo HOLD_DELETE_REPEATERS_RUNNER_COMPLETE
