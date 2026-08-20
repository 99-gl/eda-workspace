#!/usr/bin/env python3
# Usage: python verifier.py answer.json

import os, subprocess, sys
task = os.path.dirname(os.path.abspath(__file__))
sys.exit(subprocess.call([sys.executable, os.path.join(os.path.dirname(task), "static_json_verifier.py"), os.path.join(task, "gt.json"), sys.argv[1] if len(sys.argv) == 2 else ""]))
