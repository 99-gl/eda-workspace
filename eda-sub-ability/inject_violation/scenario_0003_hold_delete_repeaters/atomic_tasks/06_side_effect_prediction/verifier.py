#!/usr/bin/env python
# Usage: python verifier.py answer.json

import json, os, sys
def close(a,b,t): return abs(float(a)-b)<=t
def main():
    if len(sys.argv)!=2 or not os.path.isfile(sys.argv[1]):return 2
    with open(sys.argv[1],"r") as h:a=json.load(h)
    dirs={"hold_timing":"improve","setup_timing":"unchanged","drv":"unchanged","area":"increase","power":"increase","congestion":"unchanged"}
    ok=all(a.get(k)==v for k,v in dirs.items()) and close(a.get("hold_wns_before_ns",99),-0.019,0.002) and close(a.get("hold_wns_after_ns",99),0.006,0.003) and close(a.get("setup_wns_before_ns",99),0.390,0.002) and close(a.get("setup_wns_after_ns",99),0.390,0.002) and close(a.get("area_before_um2",0),15055.3,0.2) and close(a.get("area_after_um2",0),15056.1,0.2) and close(a.get("power_before_mw",0),19.23677394,0.0001) and close(a.get("power_after_mw",0),19.23709189,0.0001)
    print("PASS" if ok else "FAIL");return 0 if ok else 1
if __name__=="__main__":sys.exit(main())
