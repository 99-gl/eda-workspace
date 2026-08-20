#!/usr/bin/env python
# Usage: python ../static_json_verifier.py gt.json submission.json
# Compare a JSON submission with the task's exact structured reference label.

import io, json, os, sys


def main():
    if len(sys.argv) != 3:
        print("Usage: static_json_verifier.py <gt.json> <submission.json>")
        return 2
    expected_path = sys.argv[1]
    submission_path = sys.argv[2]
    if not os.path.isfile(expected_path) or not os.path.isfile(submission_path):
        print("FAIL: missing JSON file")
        return 2
    try:
        with io.open(expected_path, "r", encoding="utf-8") as handle:
            expected = json.load(handle)
        with io.open(submission_path, "r", encoding="utf-8") as handle:
            actual = json.load(handle)
    except (IOError, ValueError) as exc:
        print("FAIL: %s" % exc)
        return 1
    if actual != expected:
        print("FAIL: structured answer does not match the verifiable label")
        return 1
    print("PASS")
    return 0


if __name__ == "__main__": sys.exit(main())
