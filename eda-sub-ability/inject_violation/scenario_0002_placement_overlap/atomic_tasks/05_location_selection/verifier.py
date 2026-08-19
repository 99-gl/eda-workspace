#!/usr/bin/env python3
# Usage: python verifier.py answer.json

import json
import pathlib
import sys

task_dir = pathlib.Path(__file__).resolve().parent
if len(sys.argv) != 2:
    raise SystemExit(2)
with open(task_dir / "gt.json", encoding="utf-8") as handle:
    expected = json.load(handle)
with open(sys.argv[1], encoding="utf-8") as handle:
    actual = json.load(handle)
passed = actual == expected
print("PASS" if passed else "FAIL")
raise SystemExit(0 if passed else 1)
