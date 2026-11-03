#!/usr/bin/env bash
# Build a Lean package and enforce the repository's warning policy:
#
#   * the only warnings allowed are `declaration uses sorry`,
#   * and only in exercise files (Exercises, BugHunt, TakeHome) or the
#     deliberate `trust_me` demo in Workshop/Part5/Limits.lean,
#   * so every Solutions file and spec is sorry-free and warning-free.
#
# Usage: scripts/check.sh [package-dir]     (default: the repository root)
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
pkg="${1:-.}"
cd "$repo/$pkg"

log="$(mktemp)"
trap 'rm -f "$log"' EXIT

# Force Lake to re-print every message, not just the ones from modules it rebuilt.
if ! lake build --log-level=warning 2>&1 | tee "$log" >/dev/null; then
  cat "$log"
  echo "error: build failed in $pkg" >&2
  exit 1
fi
if grep -q "^error" "$log"; then
  grep "^error" "$log" >&2
  echo "error: build reported errors in $pkg" >&2
  exit 1
fi

allowed='(Exercises\.lean|BugHunt\.lean|/TakeHome/[A-Za-z0-9]+\.lean|Workshop/Part5/Limits\.lean):[0-9]+:[0-9]+: declaration uses .sorry.'

warnings="$(grep '^warning' "$log" || true)"
unexpected="$(echo "$warnings" | grep -v '^$' | grep -vE "$allowed" || true)"
# A `sorry` in a Solutions file is never allowed, even under a TakeHome path.
unexpected+="$(echo "$warnings" | grep -E '/Solutions/.*sorry' || true)"

holes="$(echo "$warnings" | grep -cE "$allowed" || true)"
echo "$pkg: $holes exercise hole(s) (expected \`sorry\` warnings)"

if [ -n "$unexpected" ]; then
  echo "$unexpected" >&2
  echo "error: unexpected warnings in $pkg (see above)" >&2
  exit 1
fi
echo "$pkg: OK, no other warnings"
