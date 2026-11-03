#!/usr/bin/env bash
# Check that your machine is ready for the workshop.
#
# Usage: scripts/check-setup.sh
#
# The workshop uses only Lean itself (no Mathlib, no Rust tooling), so this
# downloads the Lean version in `lean-toolchain` and builds every file.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
ok()   { printf '  \033[32m✔\033[0m %s\n' "$1"; }
fail() { printf '  \033[31m✘\033[0m %s\n' "$1"; exit 1; }

echo "Checking your setup…"

command -v elan >/dev/null || fail "elan not found. Install it: https://lean-lang.org/install/"
ok "elan $(elan --version | awk '{print $2}')"
command -v lake >/dev/null || fail "lake not found. Open a new terminal after installing elan."

cd "$repo"
echo "  … building the workshop (first run downloads Lean $(cut -d: -f2 lean-toolchain))"
lake build >/dev/null 2>&1 || fail "the workshop did not build. Run 'lake build' to see why."
ok "the workshop builds"

echo
echo "You're ready. Open this folder in VS Code (with the 'Lean 4' extension) and"
echo "open Workshop/Part2/Basics.lean to check that the infoview works."
