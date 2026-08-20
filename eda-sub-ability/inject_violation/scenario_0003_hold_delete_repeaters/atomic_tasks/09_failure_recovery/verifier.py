#!/usr/bin/env python
# Usage: python verifier.py recovery.tcl

import os, subprocess, sys
def main():
    if len(sys.argv)!=2 or not os.path.isfile(sys.argv[1]):return 2
    task_dir=os.path.dirname(os.path.abspath(__file__));env=os.environ.copy();env["SUBMISSION_TCL"]=os.path.abspath(sys.argv[1])
    proc=subprocess.Popen(["innovus","-nowin","-files","verify.tcl"],cwd=task_dir,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    out=proc.communicate()[0];out=out.decode("utf-8","replace") if not isinstance(out,str) else out
    with open(os.path.join(task_dir,"verifier.log"),"wb") as h:h.write(out.encode("utf-8"))
    ok=proc.returncode==0 and "HOLD_ATOMIC_09_COMPLETE" in out
    print("PASS" if ok else "FAIL");return 0 if ok else 1
if __name__=="__main__":sys.exit(main())
