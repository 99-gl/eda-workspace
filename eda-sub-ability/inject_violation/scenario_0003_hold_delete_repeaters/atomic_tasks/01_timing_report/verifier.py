#!/usr/bin/env python
# Usage: python verifier.py answer.json

import json, os, sys

def main():
    if len(sys.argv) != 2 or not os.path.isfile(sys.argv[1]): return 2
    with open(sys.argv[1], "r") as handle: answer = json.load(handle)
    passed = answer.get("check_type") == "hold" and answer.get("beginpoint") == "text_in[23]" and answer.get("endpoint") == "_19212_/D" and abs(float(answer.get("slack_ns", 99)) + 0.019) <= 0.002 and answer.get("path_group") == "aes_clk" and answer.get("analysis_view") == "VIEW_TYP"
    print("PASS" if passed else "FAIL")
    return 0 if passed else 1
if __name__ == "__main__": sys.exit(main())
