#!/usr/bin/env python
# Usage: python verifier.py answer.json

import json, os, sys
def main():
    if len(sys.argv)!=2 or not os.path.isfile(sys.argv[1]): return 2
    with open(sys.argv[1],"r") as h:a=json.load(h)
    ok=a.get("eco_action")=="insert_buffer" and a.get("buffer_cell")=="CLKBUF_X1"
    print("PASS" if ok else "FAIL"); return 0 if ok else 1
if __name__=="__main__":sys.exit(main())
