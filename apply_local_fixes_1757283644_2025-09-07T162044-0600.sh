#!/usr/bin/env bash
#
# apply_local_fixes.sh — CIFAR-10 local E2E fixes (idempotent)
# Run from repo root. Creates backups and is safe to re-run.

set -euo pipefail

# ------------ Helpers ------------
msg() { printf "\033[1;32m[fix]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[err]\033[0m %s\n" "$*" >&2; }
ensure_dir() { [ -d "$1" ] || { mkdir -p "$1"; msg "mkdir -p $1"; }; }

# Derive TAG and TAGDIR if possible; fall back gracefully.
PROJECT_ROOT="$(pwd)"
TAGDIR="${TAGDIR:-$PROJECT_ROOT}"
TAG="${TAG:-$(basename "$TAGDIR")}"

msg "PROJECT_ROOT=${PROJECT_ROOT}"
msg "TAGDIR=${TAGDIR}"
msg "TAG=${TAG}"

# Basic layout
ensure_dir "bin"
ensure_dir "scripts"
ensure_dir "outputs/csv_logs"
ensure_dir "datasets"
ensure_dir "notebooks"
ensure_dir "scripts/tests"

# ------------ 1) structure.sh cleanup & EARLY --check hook ------------
if [ -f "structure.sh" ]; then
  # Quiet, portable backup (timestamped)
  cp -p structure.sh "structure.sh.bak.$(date +%s)"

  # Clean stray banner lines referencing $gitattr_path / $tag (safe filter).
  if grep -Eq '\$gitattr_path|\$tag.*(banner|provided for tag|try|scaffold)' structure.sh; then
    msg "Cleaning banner lines in structure.sh"
    awk '
      /gitattr_path/ {next}
      /\$tag/ && /(banner|provided for tag|try|scaffold)/ {next}
      {print}
    ' structure.sh > structure.sh.__tmp && mv structure.sh.__tmp structure.sh
  else
    msg "No banner cruft found in structure.sh (nothing to clean)."
  fi

  # Insert EARLY --check hook (before any usage/arg checks), only if absent
  if ! grep -q 'ALF_EARLY_CHECK_HOOK' structure.sh; then
    msg "Inserting early --check hook into structure.sh"
    awk '
      NR==1 && $0 ~ /^#!/ {
        print $0
        print ""
        print "# --- ALF_EARLY_CHECK_HOOK: inserted by apply_local_fixes.sh ---"
        print "if [ \"${1:-}\" = \"--check\" ]; then"
        print "  set -euo pipefail"
        print "  ROOT=\"$(git rev-parse --show-toplevel 2>/dev/null || pwd)\""
        print "  TAGDIR_LOCAL=\"${TAGDIR:-$ROOT}\""
        print "  TAG_LOCAL=\"${TAG:-$(basename \"$TAGDIR_LOCAL\")}\""
        print "  missing=0"
        print "  cd \"$ROOT\""
        print "  say(){ printf \"%s\\n\" \"$*\"; }"
        print "  for p in datasets outputs outputs/csv_logs scripts notebooks; do"
        print "    [ -e \"$p\" ] || { say \"MISSING: $p\"; missing=1; }"
        print "  done"
        print "  PY_UTIL=\"scripts/py_utils_${TAG_LOCAL}.py\""
        print "  NB=\"notebooks/02_training_${TAG_LOCAL}.ipynb\""
        print "  [ -e \"$PY_UTIL\" ] || { say \"MISSING: $PY_UTIL\"; missing=1; }"
        print "  [ -e \"$NB\" ] || { say \"MISSING: $NB\"; missing=1; }"
        print "  exit $missing"
        print "fi"
        print "# --- end ALF_EARLY_CHECK_HOOK ---"
        next
      }
      NR==1 && $0 !~ /^#!/ {
        print "#!/usr/bin/env bash"
        print ""
        print "# --- ALF_EARLY_CHECK_HOOK: inserted by apply_local_fixes.sh ---"
        print "if [ \"${1:-}\" = \"--check\" ]; then"
        print "  set -euo pipefail"
        print "  ROOT=\"$(git rev-parse --show-toplevel 2>/dev/null || pwd)\""
        print "  TAGDIR_LOCAL=\"${TAGDIR:-$ROOT}\""
        print "  TAG_LOCAL=\"${TAG:-$(basename \"$TAGDIR_LOCAL\")}\""
        print "  missing=0"
        print "  cd \"$ROOT\""
        print "  say(){ printf \"%s\\n\" \"$*\"; }"
        print "  for p in datasets outputs outputs/csv_logs scripts notebooks; do"
        print "    [ -e \"$p\" ] || { say \"MISSING: $p\"; missing=1; }"
        print "  done"
        print "  PY_UTIL=\"scripts/py_utils_${TAG_LOCAL}.py\""
        print "  NB=\"notebooks/02_training_${TAG_LOCAL}.ipynb\""
        print "  [ -e \"$PY_UTIL\" ] || { say \"MISSING: $PY_UTIL\"; missing=1; }"
        print "  [ -e \"$NB\" ] || { say \"MISSING: $NB\"; missing=1; }"
        print "  exit $missing"
        print "fi"
        print "# --- end ALF_EARLY_CHECK_HOOK ---"
        print ""
      }
      { print }
    ' structure.sh > structure.sh.__tmp && mv structure.sh.__tmp structure.sh
  else
    msg "Early --check hook already present."
  fi

else
  warn "structure.sh not found; skipping its fixes."
fi

# ------------ 2) scripts/py_utils_<tag>.py with log_test_summary ------------
PY_UTIL="scripts/py_utils_${TAG}.py"
if [ -f "$PY_UTIL" ]; then
  if grep -q 'def log_test_summary' "$PY_UTIL"; then
    msg "$PY_UTIL already defines log_test_summary()"
  else
    msg "Appending log_test_summary() to existing $PY_UTIL"
    cat >> "$PY_UTIL" <<'PYAPPEND'

def log_test_summary(acc, loss, seed, tagdir):
    """Write test summary JSON to outputs/, returning the path."""
    from pathlib import Path
    import json, time
    ts = int(time.time())
    out = Path(tagdir) / "outputs" / f"test_summary_seed{int(seed)}_{ts}.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w") as f:
        json.dump(
            {"acc": float(acc), "loss": float(loss), "seed": int(seed), "ts": ts},
            f,
        )
    return str(out)
PYAPPEND
  fi
else
  msg "Creating $PY_UTIL with log_test_summary()"
  cat > "$PY_UTIL" <<'PYNEW'
# Auto-generated by apply_local_fixes.sh
from pathlib import Path
import json, time

def log_test_summary(acc, loss, seed, tagdir):
    """Write test summary JSON to outputs/, returning the path."""
    ts = int(time.time())
    out = Path(tagdir) / "outputs" / f"test_summary_seed{int(seed)}_{ts}.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w") as f:
        json.dump(
            {"acc": float(acc), "loss": float(loss), "seed": int(seed), "ts": ts},
            f,
        )
    return str(out)
PYNEW
fi

# ------------ 3) Ensure placeholder training notebook ------------
NB="notebooks/02_training_${TAG}.ipynb"
if [ -f "$NB" ]; then
  msg "$NB already exists."
else
  msg "Creating placeholder $NB (minimal valid ipynb so --check can pass)."
  cat > "$NB" <<'IPY'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# 02_training_<tag> (placeholder)\n",
    "\n",
    "This placeholder is created by apply_local_fixes.sh so `structure.sh --check` passes.\n",
    "Replace with your real training notebook for the tag."
   ]
  }
 ],
 "metadata": {
  "kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"},
  "language_info": {"name": "python"}
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
IPY
fi

# ------------ 4) bin/helpers.sh with enhanced elapsed() ------------
HELPERS="bin/helpers.sh"
if [ -f "$HELPERS" ]; then
  msg "Updating $HELPERS (ensuring elapsed() present)"
else
  msg "Creating $HELPERS"
  touch "$HELPERS"
fi

# Only append if not already present
if ! grep -q 'elapsed()[[:space:]]*{' "$HELPERS"; then
  cat >> "$HELPERS" <<'HLP'

# --- helpers: elapsed timer & format (idempotent) ---
# elapsed: start/stop/check a stopwatch stored at /tmp/.elapsed_timer
# Prints: "<total_seconds> (<D>d )HH:MM:SS"
elapsed() {
  local f=/tmp/.elapsed_timer
  _fmt_dhms() {
    # arg: total seconds -> prints "(<D>d )HH:MM:SS"
    local t=$1
    local d=$(( t/86400 ))
    local h=$(( (t%86400)/3600 ))
    local m=$(( (t%3600)/60 ))
    local s=$(( t%60 ))
    if (( d > 0 )); then
      printf "%dd %02d:%02d:%02d" "$d" "$h" "$m" "$s"
    else
      printf "%02d:%02d:%02d" "$h" "$m" "$s"
    fi
  }
  case "${1:-}" in
    -s|--start)
      [ -e "$f" ] && { echo "already started"; return 1; }
      date +%s >"$f"; echo "started"
      ;;
    -p|--stop)
      [ ! -e "$f" ] && { echo "not started"; return 1; }
      local s=$(cat "$f"); rm -f "$f"
      local now=$(date +%s)
      local t=$(( now - s ))
      printf "%d (%s)\n" "$t" "$(_fmt_dhms "$t")"
      ;;
    -c|--check|--status)
      [ ! -e "$f" ] && { echo "not started"; return 1; }
      local s=$(cat "$f")
      local now=$(date +%s)
      local t=$(( now - s ))
      printf "%d (%s)\n" "$t" "$(_fmt_dhms "$t")"
      ;;
    -h|--help|*)
      cat <<'H'
Usage: elapsed [--start|-s] | [--stop|-p] | [--check|-c] | [--help|-h]
  --start  start timer (guards against double-start)
  --stop   print total seconds and (D)d HH:MM:SS, then clear
  --check  print total seconds and (D)d HH:MM:SS (continues running)
H
      ;;
  esac
}
# --- end helpers: elapsed ---
HLP
else
  msg "helpers.sh already contains elapsed()."
fi

chmod +x "$HELPERS"

# Print sourcing instruction prominently
msg "Use: source \"$PROJECT_ROOT/bin/helpers.sh\" for \`elapsed\` and future helpers."
msg "Header: source bin/safe_default_header.sh (or your existing bin/safe_local_header.sh) in dev scripts."

# ------------ 5) Headers: default vs local ------------
SAFE_LOCAL="bin/safe_local_header.sh"
SAFE_DEF="bin/safe_default_header.sh"

# Case A: You already maintain a local header; ensure a wrapper default exists.
if [ -f "$SAFE_LOCAL" ] && [ ! -f "$SAFE_DEF" ]; then
  msg "Detected $SAFE_LOCAL; creating wrapper $SAFE_DEF that sources it."
  cat > "$SAFE_DEF" <<'WRAP'
#!/usr/bin/env bash
# Wrapper: prefer developer-maintained local header.
# Do not modify this file; edit bin/safe_local_header.sh instead.
source "$(git rev-parse --show-toplevel 2>/dev/null || pwd)/bin/safe_local_header.sh"
WRAP
  chmod +x "$SAFE_DEF"
fi

# Case B: Neither exists — create the default template.
if [ ! -f "$SAFE_LOCAL" ] && [ ! -f "$SAFE_DEF" ]; then
  msg "Creating template $SAFE_DEF"
  cat > "$SAFE_DEF" <<'SAFE'

#!/usr/bin/env bash
# safe_default_header.sh — DEV-ONLY shell header (template)
# This header is meant for local/dev shells and notebooks. DO NOT source in production scripts or Docker images.
# Recommended usage in dev scripts:
#   source "$(git rev-parse --show-toplevel 2>/dev/null || echo .)/bin/safe_default_header.sh"
#
# What this header SHOULD do (you can customize below as needed):
#   - set -Eeuo pipefail
#   - sane IFS
#   - detect PROJECT_ROOT and export TAG/TAGDIR defaults if unset
#   - minimal logging helpers (say, warn, err)

# --- Safe defaults ---
set -Eeuo pipefail
IFS=$' \t\n'

# PROJECT_ROOT resolution (git root or cwd)
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
export PROJECT_ROOT

# TAG/TAGDIR fallbacks (non-invasive)
export TAG="${TAG:-$(basename "$PROJECT_ROOT")}"
export TAGDIR="${TAGDIR:-$PROJECT_ROOT}"

# Minimal log helpers
say()  { printf "\033[1;34m[info]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[err]\033[0m %s\n" "$*"; }  # stderr

# You may add dev-only exports or path tweaks below as needed.
# e.g., export PYTHONWARNINGS=default

SAFE
  chmod +x "$SAFE_DEF"
fi

# ------------ 6) Test script (short + simulated 1d) ------------
TEST_SCRIPT="scripts/tests/test_elapsed_all.sh"
if [ ! -f "$TEST_SCRIPT" ]; then
  msg "Creating $TEST_SCRIPT"
  cat > "$TEST_SCRIPT" <<'TEST'
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
TEST
  chmod +x "$TEST_SCRIPT"
else
  msg "$TEST_SCRIPT already exists; leaving as-is."
fi

# ------------ 7) Makefile target ------------
MAKEFILE="Makefile"
ADD_TARGET=0
if [ -f "$MAKEFILE" ]; then
  if grep -qE '^[.]PHONY:\s*test-elapsed' "$MAKEFILE" || grep -qE '^test-elapsed:' "$MAKEFILE"; then
    msg "Makefile already has a test-elapsed target."
  else
    ADD_TARGET=1
  fi
else
  msg "Creating Makefile"
  touch "$MAKEFILE"
  ADD_TARGET=1
fi

if [ "$ADD_TARGET" -eq 1 ]; then
  msg "Appending test-elapsed target to Makefile"
  cat >> "$MAKEFILE" <<'MK'

.PHONY: test-elapsed
test-elapsed:
	@bash scripts/tests/test_elapsed_all.sh
MK
fi

# ------------ 8) Final check (now that early hook exists) & README note ------------
if [ -f "structure.sh" ]; then
  msg "Running: bash structure.sh --check"
  if bash structure.sh --check; then
    msg "Scaffold check PASSED."
  else
    err "Scaffold check FAILED (see missing items above)."
    exit 1
  fi
else
  warn "Skipped scaffold check (no structure.sh present)."
fi

msg "Local fixes applied."

# README note uses 'iii' fences to avoid mangling in chat UIs.
cat <<'README_NOTE'

----- README NOTE (paste into README.md) -----

### Dev Shell Headers & Helpers

For **local/dev use only** (not production or Docker images):

iii
# Load safe defaults (strict shell, sane env)
# Use whichever header you maintain:
source "$PROJECT_ROOT/bin/safe_default_header.sh"   # if using generated template
# OR
source "$PROJECT_ROOT/bin/safe_local_header.sh"     # if you maintain your own

# Load helper functions (e.g., elapsed)
source "$PROJECT_ROOT/bin/helpers.sh"
iii

- `safe_default_header.sh` (auto-generated) or `safe_local_header.sh` (your own) sets strict Bash options (`set -Eeuo pipefail`), a sane `IFS`, detects `PROJECT_ROOT`, and provides non-invasive defaults for `TAG` and `TAGDIR`.
- `helpers.sh` contains utilities including `elapsed`, which works like:
  - `elapsed --start` start the stopwatch
  - `elapsed --check` prints `<seconds> (Dd HH:MM:SS)` and keeps running
  - `elapsed --stop` prints `<seconds> (Dd HH:MM:SS)` and clears

> **Important:** Do **not** source these headers inside production entrypoints or Docker container scripts. Keep them dev-only to prevent environment surprises.

----- END README NOTE -----

README_NOTE

msg "Reminder: run environment sanity once per machine:"
echo "  python ~/my_repos_dwb/fhtw-paper-code-prep/verify_env.py"

# Optional: suggest EOL normalization if script exists
if [ -f "scripts/normalize_eol.py" ]; then
  msg "You can normalize EOLs with:"
  echo '  python scripts/normalize_eol.py --root "$TAGDIR" --map "sh=lf,ps1=crlf,cmd=crlf,py=lf,ipynb=lf,md=lf"'
fi
