#!/usr/bin/env python
# Usage: python verifier.py answer.json

import json, os, sys

def main():
    if len(sys.argv) != 2 or not os.path.isfile(sys.argv[1]): return 2
    with open(sys.argv[1], "r", encoding="utf-8") as handle: answer = json.load(handle)
    objects = set(answer.get("primary_objects", [])); evidence = str(answer.get("evidence", "")).lower()
    passed = answer.get("root_cause") == "cell_delay" and answer.get("contributing_factor") == "repeater_deletion" and objects == {"FE_PHC917_00140", "FE_PHC1249_00140"} and ("delay" in evidence or "延迟" in evidence)
    print("PASS" if passed else "FAIL"); return 0 if passed else 1
if __name__ == "__main__": sys.exit(main())
