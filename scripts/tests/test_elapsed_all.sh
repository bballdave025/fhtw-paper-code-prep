#!/usr/bin/env bash
# scripts/tests/test_elapsed_all.sh — end-to-end tests for bin/helpers.sh:elapsed

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
HELPERS="$ROOT/bin/helpers.sh"
TIMER_FILE="/tmp/.elapsed_timer"

fail() { printf "\033[1;31m[FAIL]\033[0m %s\n" "$*" >&2; exit 1; }
pass() { printf "\033[1;32m[PASS]\033[0m %s\n" "$*\n"; }
info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*\n"; }

[ -f "$HELPERS" ] || fail "Missing $HELPERS. Run ./apply_local_fixes.sh first."

# shellcheck disable=SC1090
source "$HELPERS"

# Utility: parse "<secs> (Dd HH:MM:SS)"
get_secs() { awk '{print $1}' <<<"$1"; }
expect_between() {
  local val="$1" lo="$2" hi="$3" label="$4"
  if (( val < lo || val > hi )); then
    fail "$label expected between $lo and $hi, got $val"
  fi
}

# --- Short duration test ---
info "Short duration test"
elapsed --start >/dev/null
sleep 2
out=$(elapsed --check)    # ~2
sec=$(get_secs "$out")
expect_between "$sec" 2 3 "check ~2s"
sleep 3
out=$(elapsed --stop)     # ~5
sec=$(get_secs "$out")
expect_between "$sec" 5 6 "stop ~5s"
pass "Short duration test OK: $out"

# Confirm cleared
if elapsed --check 2>/dev/null; then
  fail "Timer should be cleared after --stop"
fi
info "Timer cleared after short test"

# --- Long duration simulation (≈ 90,000 s = 1d 01:00:00) ---
info "Long duration simulation (~90000s)"
fake_start=$(( $(date +%s) - 90000 ))
echo "$fake_start" > "$TIMER_FILE"

out=$(elapsed --check)
sec=$(get_secs "$out")
expect_between "$sec" 89995 90005 "simulated check ~90000s"

out=$(elapsed --stop)
sec=$(get_secs "$out")
expect_between "$sec" 89995 90005 "simulated stop ~90000s"
pass "Long duration simulation OK: $out"

# Final cleared confirm
if elapsed --check 2>/dev/null; then
  fail "Timer should be cleared after simulated --stop"
fi
pass "Elapsed tests completed successfully."
