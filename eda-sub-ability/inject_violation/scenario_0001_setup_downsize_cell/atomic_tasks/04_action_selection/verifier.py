#!/usr/bin/env python3
# Usage: python3 verifier.py [answer.json]

import json
import sys
from pathlib import Path

path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("answer.json")
answer = json.loads(path.read_text(encoding="utf-8"))
mapping = {"_16419_": "OAI21_X4", "_16425_": "OAI221_X4", "_16427_": "OAI21_X4"}
ok = answer.get("eco_action") == "size_cell" and answer.get("cell_mapping") == mapping
print("PASS" if ok else "FAIL")
raise SystemExit(0 if ok else 1)
