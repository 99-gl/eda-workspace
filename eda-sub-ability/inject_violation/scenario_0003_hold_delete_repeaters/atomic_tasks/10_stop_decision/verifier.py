#!/usr/bin/env python
# Usage: python verifier.py answer.json

import json, os, sys
def main():
    if len(sys.argv)!=2 or not os.path.isfile(sys.argv[1]):return 2
    with open(sys.argv[1],"r",encoding="utf-8") as h:a=json.load(h)
    acc=a.get("acceptance",{});reason=str(a.get("reason","")).lower()
    ok=a.get("decision")=="stop" and a.get("extra_eco_required") is False and all(acc.get(k) is True for k in ("timing","drv","physical")) and ("闭合" in reason or "closed" in reason)
    print("PASS" if ok else "FAIL");return 0 if ok else 1
if __name__=="__main__":sys.exit(main())
