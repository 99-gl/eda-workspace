#!/usr/bin/env python3
# Usage: python3 verifier.py [answer.json]

import json
import math
import sys
from pathlib import Path

path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("answer.json")
answer = json.loads(path.read_text(encoding="utf-8"))
expected = json.loads(Path(__file__).with_name("gt.json").read_text(encoding="utf-8"))
directions = ("setup_timing", "hold_timing", "drv", "area", "power", "congestion")
ok = all(answer.get(key) == expected[key] for key in directions)
for key in set(expected) - set(directions):
    value = answer.get(key)
    ok = ok and isinstance(value, (int, float)) and math.isclose(value, expected[key], abs_tol=0.002, rel_tol=0.001)
print("PASS" if ok else "FAIL")
raise SystemExit(0 if ok else 1)
