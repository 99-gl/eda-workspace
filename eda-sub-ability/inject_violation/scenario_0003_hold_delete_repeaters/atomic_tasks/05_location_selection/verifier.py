#!/usr/bin/env python
# Usage: python verifier.py answer.json

import json, os, sys
def main():
    if len(sys.argv)!=2 or not os.path.isfile(sys.argv[1]):return 2
    with open(sys.argv[1],"r") as h:a=json.load(h)
    loc=a.get("location_um",[99,99]); ok=a.get("target_net")=="_00140_" and a.get("target_sinks")==["FE_PHC963_00140/A"] and a.get("buffer_cell")=="CLKBUF_X1" and len(loc)==2 and abs(float(loc[0])-47.31)<=0.01 and abs(float(loc[1])-19.88)<=0.01
    print("PASS" if ok else "FAIL");return 0 if ok else 1
if __name__=="__main__":sys.exit(main())
