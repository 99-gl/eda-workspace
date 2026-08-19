#!/usr/bin/env python3
# Usage: python3 verifier.py [answer.json]

import json
import math
import sys
from pathlib import Path

answer_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("answer.json")
answer = json.loads(answer_path.read_text(encoding="utf-8"))
expected = json.loads(Path(__file__).with_name("gt.json").read_text(encoding="utf-8"))
errors = []
for key in ("check_type", "beginpoint", "endpoint", "path_group", "analysis_view"):
    if answer.get(key) != expected[key]:
        errors.append(f"{key}: expected {expected[key]!r}, got {answer.get(key)!r}")
slack = answer.get("slack_ns")
if not isinstance(slack, (int, float)) or not math.isclose(slack, expected["slack_ns"], abs_tol=0.002):
    errors.append(f"slack_ns: expected {expected['slack_ns']}, got {slack!r}")
if errors:
    print("FAIL\n- " + "\n- ".join(errors))
    raise SystemExit(1)
print("PASS")
