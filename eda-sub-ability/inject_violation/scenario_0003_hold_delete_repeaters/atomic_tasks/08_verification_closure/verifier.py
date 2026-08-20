#!/usr/bin/env python
# Usage: python verifier.py answer.json

import json, os, sys
def main():
    if len(sys.argv)!=2 or not os.path.isfile(sys.argv[1]):return 2
    with open(sys.argv[1],"r") as h:a=json.load(h)
    ok=a.get("status")=="closed" and abs(float(a.get("setup_wns_ns",99))-0.390)<=0.002 and abs(float(a.get("setup_tns_ns",99)))<=0.001 and abs(float(a.get("hold_wns_ns",99))-0.006)<=0.003 and abs(float(a.get("hold_tns_ns",99)))<=0.001 and all(a.get(k) is True for k in ("drv_clean","drc_clean","connectivity_clean","placement_clean"))
    print("PASS" if ok else "FAIL");return 0 if ok else 1
if __name__=="__main__":sys.exit(main())
