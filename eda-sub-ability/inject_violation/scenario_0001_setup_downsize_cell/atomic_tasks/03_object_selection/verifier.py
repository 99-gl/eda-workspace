#!/usr/bin/env python3
# Usage: python3 verifier.py [answer.json]

import json
import sys
from pathlib import Path

path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("answer.json")
answer = json.loads(path.read_text(encoding="utf-8"))
ok = answer.get("object_type") == "instance" and set(answer.get("object_names", [])) == {"_16419_", "_16425_", "_16427_"}
print("PASS" if ok else "FAIL")
raise SystemExit(0 if ok else 1)
