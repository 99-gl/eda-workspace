#!/usr/bin/env python
# Usage: python verifier.py repair.tcl

import os
import subprocess
import sys


def main():
    if len(sys.argv) != 2:
        sys.stderr.write("usage: python verifier.py repair.tcl\n")
        return 2
    task_dir = os.path.dirname(os.path.abspath(__file__))
    submission = os.path.abspath(sys.argv[1])
    if not os.path.isfile(submission):
        sys.stderr.write("missing submission: {0}\n".format(submission))
        return 2
    env = os.environ.copy()
    env["SUBMISSION_TCL"] = str(submission)
    process = subprocess.Popen(
        ["innovus", "-nowin", "-files", "verify.tcl"],
        cwd=task_dir,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    output = process.communicate()[0]
    if not isinstance(output, str):
        output = output.decode("utf-8", "replace")
    log = os.path.join(task_dir, "verifier.log")
    with open(log, "wb") as handle:
        handle.write(output.encode("utf-8"))
    passed = process.returncode == 0 and "ATOMIC_07_PASS" in output
    print("PASS" if passed else "FAIL (see {0})".format(log))
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
