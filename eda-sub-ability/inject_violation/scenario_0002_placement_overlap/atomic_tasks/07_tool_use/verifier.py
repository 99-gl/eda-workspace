#!/usr/bin/env python
# Usage: python verifier.py repair.tcl

import os
import re
import subprocess
import sys

def read_text(path):
    with open(path, "rb") as handle:
        data = handle.read()
    return data.decode("utf-8", "replace") if not isinstance(data, str) else data

def main():
    if len(sys.argv) != 2 or not os.path.isfile(sys.argv[1]):
        return 2
    task_dir = os.path.dirname(os.path.abspath(__file__))
    env = os.environ.copy()
    env["SUBMISSION_TCL"] = os.path.abspath(sys.argv[1])
    proc = subprocess.Popen(["innovus", "-nowin", "-files", "verify.tcl"], cwd=task_dir, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = proc.communicate()[0]
    if not isinstance(output, str):
        output = output.decode("utf-8", "replace")
    with open(os.path.join(task_dir, "verifier.log"), "wb") as handle:
        handle.write(output.encode("utf-8"))
    reports = os.path.join(task_dir, "verifier_reports")
    placement = read_text(os.path.join(reports, "placement.rpt")) if os.path.isfile(os.path.join(reports, "placement.rpt")) else ""
    connectivity = read_text(os.path.join(reports, "connectivity.rpt")) if os.path.isfile(os.path.join(reports, "connectivity.rpt")) else ""
    drc = read_text(os.path.join(reports, "drc.rpt")) if os.path.isfile(os.path.join(reports, "drc.rpt")) else ""
    setup = read_text(os.path.join(reports, "setup.rpt")) if os.path.isfile(os.path.join(reports, "setup.rpt")) else ""
    hold = read_text(os.path.join(reports, "hold.rpt")) if os.path.isfile(os.path.join(reports, "hold.rpt")) else ""
    constraints = read_text(os.path.join(reports, "constraints.rpt")) if os.path.isfile(os.path.join(reports, "constraints.rpt")) else ""
    setup_match = re.search(r"= Slack Time\s+(-?[0-9.]+)", setup)
    hold_match = re.search(r"Slack Time\s+(-?[0-9.]+)", hold)
    report_ok = "Unplaced = 0" in placement and "Overlapping" not in placement and "Found no problems or warnings" in connectivity and "No DRC violations were found" in drc and "VIOLATED" not in constraints and setup_match and hold_match and float(setup_match.group(1)) >= 0.0 and float(hold_match.group(1)) >= 0.0
    passed = proc.returncode == 0 and "PLACEMENT_ATOMIC_07_COMPLETE" in output and report_ok
    print("PASS" if passed else "FAIL")
    return 0 if passed else 1

if __name__ == "__main__":
    sys.exit(main())
