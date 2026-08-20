#!/usr/bin/env python
# Usage: python verifier.py repair.tcl

import os, re, subprocess, sys


def main():
    if len(sys.argv) != 2 or not os.path.isfile(sys.argv[1]):
        return 2
    task_dir = os.path.dirname(os.path.abspath(__file__))
    env = os.environ.copy()
    env["SUBMISSION_TCL"] = os.path.abspath(sys.argv[1])
    devnull = open(os.devnull, "rb")
    proc = subprocess.Popen(["innovus", "-nowin", "-files", "verify.tcl"], cwd=task_dir, env=env, stdin=devnull, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = proc.communicate()[0]
    devnull.close()
    text = output.decode("utf-8", "replace") if not isinstance(output, str) else output
    with open(os.path.join(task_dir, "verifier.log"), "wb") as handle:
        handle.write(text.encode("utf-8"))
    reports = os.path.join(task_dir, "verifier_reports")
    required = ["fanout.rpt", "transition.rpt", "capacitance.rpt", "setup.rpt", "hold.rpt", "placement.rpt", "connectivity.rpt", "drc.rpt"]
    if proc.returncode != 0 or "MAX_FANOUT_ATOMIC_07_COMPLETE" not in text or any(not os.path.isfile(os.path.join(reports, name)) or os.path.getsize(os.path.join(reports, name)) == 0 for name in required):
        print("FAIL")
        return 1
    def read_report(name):
        with open(os.path.join(reports, name), "rb") as handle:
            data = handle.read()
        return data.decode("utf-8", "replace") if not isinstance(data, str) else data
    fanout, tran, cap = read_report("fanout.rpt"), read_report("transition.rpt"), read_report("capacitance.rpt")
    setup, hold = read_report("setup.rpt"), read_report("hold.rpt")
    ok = "0 violation is real" in fanout and "there is 0 max_tran violation" in tran and "there is 0 max_cap violation" in cap
    sm = re.search(r"= Slack Time\s+(-?[0-9.]+)", setup)
    hm = re.search(r"Slack Time\s+(-?[0-9.]+)", hold)
    ok = ok and sm is not None and hm is not None and float(sm.group(1)) >= 0 and float(hm.group(1)) >= 0
    print("PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__": sys.exit(main())
