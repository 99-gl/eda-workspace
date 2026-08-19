#!/usr/bin/env python3
# Usage: python3 verifier.py [answer.json]

import json
import sys
from pathlib import Path

root = Path(__file__).resolve().parent
path = Path(sys.argv[1]) if len(sys.argv) > 1 else root / "answer.json"
answer = json.loads(path.read_text(encoding="utf-8"))
acceptance = answer.get("acceptance", {})
ok = (
    answer.get("decision") == "stop"
    and all(acceptance.get(key) is True for key in ("timing", "drv", "physical"))
    and isinstance(answer.get("reason"), str)
    and len(answer["reason"].strip()) >= 15
    and not (root / "repair.tcl").exists()
)
print("PASS" if ok else "FAIL")
raise SystemExit(0 if ok else 1)
