#!/usr/bin/env python
# Usage: python verifier.py recovery.tcl

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
    if not isinstance(output, str): output = output.decode("utf-8", "replace")
    with open(os.path.join(task_dir, "verifier.log"), "wb") as handle: handle.write(output.encode("utf-8"))
    reports = os.path.join(task_dir, "verifier_reports")
    paths = [os.path.join(reports, name) for name in ("placement.rpt", "connectivity.rpt", "drc.rpt", "setup.rpt", "hold.rpt", "constraints.rpt")]
    report_ok = all(os.path.isfile(path) for path in paths)
    if report_ok:
        setup_match = re.search(r"= Slack Time\s+(-?[0-9.]+)", read_text(paths[3]))
        hold_match = re.search(r"Slack Time\s+(-?[0-9.]+)", read_text(paths[4]))
        report_ok = "Unplaced = 0" in read_text(paths[0]) and "Overlapping" not in read_text(paths[0]) and "Found no problems or warnings" in read_text(paths[1]) and "No DRC violations were found" in read_text(paths[2]) and setup_match and hold_match and float(setup_match.group(1)) >= 0.0 and float(hold_match.group(1)) >= 0.0 and "VIOLATED" not in read_text(paths[5])
    passed = proc.returncode == 0 and "PLACEMENT_ATOMIC_09_COMPLETE" in output and report_ok
    print("PASS" if passed else "FAIL")
    return 0 if passed else 1

if __name__ == "__main__": sys.exit(main())
