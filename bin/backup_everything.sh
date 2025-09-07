#!/usr/bin/env bash
# @file : backup_everything.sh
# Backup an experiment tag plus optional extras, with firstline audits.
# Usage:
#   backup_everything.sh <ROOT_DIR> <tag_path> [--expanded] [--skip-sys] [--skip-nbs] [--fix-firstline]
# Notes:
# - --expanded bundles: environment_specifications/, bin/, and validate_env.py output.
# - We DO NOT call backup_notebook_bakstamp.sh (that’s for one-off notebooks).
#
# Typical COMPLETE Usage example
#
# ROOT=~/my_repos_dwb/fhtw-paper-code-prep
#
# #  Tight backup with “before” firstline report
# "$ROOT/bin/backup_everything.sh" "$ROOT" test_project_bash/p01
#
# #  Expanded backup (adds env specs, bin/, validate_env.py output) + apply
# #+ fixes and include “after” report
# "$ROOT/bin/backup_everything.sh" "$ROOT" test_project_bash/p_01 --expanded --fix-firstline
#
set -euo pipefail

if (( $# < 2 )); then
  echo "Usage: $(basename "$0") <ROOT_DIR> <tag_path> [--expanded] [--skip-sys] [--skip-nbs] [--fix-firstline]" >&2
  exit 2
fi

ROOT="$1"; shift
TAG="$1";  shift

EXPANDED=0
RUN_SYS=1
RUN_NBS=1
DO_FIX_FIRSTLINE=0
while (( $# )); do
  case "$1" in
    --expanded) EXPANDED=1 ;;
    --skip-sys) RUN_SYS=0 ;;
    --skip-nbs) RUN_NBS=0 ;;
    --fix-firstline) DO_FIX_FIRSTLINE=1 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

cd "$ROOT"

TS="$(date +'%s_%Y-%m-%dT%H%M%S%z')"
BKP_DIR="$ROOT/backups"
mkdir -p "$BKP_DIR"

# Staging area for meta artifacts to include in the tarball
STAGE="$BKP_DIR/_staging_$TS"
mkdir -p "$STAGE/backup_meta"
META="$STAGE/backup_meta"

# 1) Firstline audit (before) via fix_firstline_glitches.sh --dry-run
FIXER="$ROOT/bin/fix_firstline_glitches.sh"
if [[ -x "$FIXER" ]]; then
  echo "[info] Running firstline audit (before) ..."
  if "$FIXER" --dry-run >"$META/firstline_before.txt" 2>"$META/firstline_before.err"; then
    echo "ok" > "$META/firstline_before.status"
  else
    echo "nonzero-exit" > "$META/firstline_before.status"
  fi
else
  echo "[info] No fixer found at $FIXER (skipping firstline audit)."
fi

# 2) Optional: perform fixes and capture after-report
if [[ -x "$FIXER" && $DO_FIX_FIRSTLINE -eq 1 ]]; then
  echo "[info] Applying firstline fixes (live) ..."
  if "$FIXER" >"$META/firstline_after.txt" 2>"$META/firstline_after.err"; then
    echo "ok" > "$META/firstline_after.status"
  else
    echo "nonzero-exit" > "$META/firstline_after.status"
  fi
fi

# 3) Optional helpers
if (( RUN_SYS )) && [[ -x "$ROOT/bin/sys_capture.sh" ]]; then
  echo "[info] Running sys_capture.sh ..."
  "$ROOT/bin/sys_capture.sh" >"$META/sys_capture_stdout.txt" 2>"$META/sys_capture_stderr.txt" || echo "nonzero-exit" > "$META/sys_capture_status.txt"
  [[ -f "$META/sys_capture_status.txt" ]] || echo "ok" > "$META/sys_capture_status.txt"
fi

if (( RUN_NBS )) && [[ -x "$ROOT/bin/backup_notebooks.sh" ]]; then
  echo "[info] Running backup_notebooks.sh (all notebooks) ..."
  "$ROOT/bin/backup_notebooks.sh" >"$META/backup_notebooks_stdout.txt" 2>"$META/backup_notebooks_stderr.txt" || echo "nonzero-exit" > "$META/backup_notebooks_status.txt"
  [[ -f "$META/backup_notebooks_status.txt" ]] || echo "ok" > "$META/backup_notebooks_status.txt"
fi

# 4) Validate env (always validate_env.py if present)
if (( EXPANDED )) && [[ -f "$ROOT/validate_env.py" ]]; then
  echo "[info] Running validate_env.py ..."
  { python "$ROOT/validate_env.py"; } >"$META/validate_env_stdout.txt" 2>"$META/validate_env_stderr.txt" || true
fi

# 5) Build include list
INCLUDE_PATHS=( "$TAG" "$STAGE" )
if (( EXPANDED )); then
  [[ -d environment_specifications ]] && INCLUDE_PATHS+=( environment_specifications )
  [[ -d bin ]]                        && INCLUDE_PATHS+=( bin )
fi

OUT_BASE="$(echo "$TAG" | tr '/' '_')"
OUT_NAME="${OUT_BASE}_$TS"
[[ $EXPANDED -eq 1 ]] && OUT_NAME="${OUT_BASE}_plus_env_and_bin_$TS"
OUT="$BKP_DIR/${OUT_NAME}.tar.gz"

# 6) Create archive (aligns with your atreea-style exclusions)
tar --create --gzip --file "$OUT" \
  --exclude='*/outputs/*' \
  --exclude='*/datasets/*' \
  --exclude='*/models/*' \
  --exclude='*/what_was_inside_notebook_directory_try1/*' \
  --exclude='*/.ipynb_checkpoints/*' \
  --exclude='*/__pycache__/*' \
  --exclude='*/bash_terminal_io_lab_notebooks/*' \
  --exclude='*/.DS_Store' \
  "${INCLUDE_PATHS[@]}"

# 7) Quick verify + checksum
COUNT=$(tar -tzf "$OUT" | wc -l | awk '{print $1}')
echo "[ok] Archive contains $COUNT entries."
sha256sum "$OUT" | tee "$OUT.sha256" >/dev/null
echo "[ok] Backup written: $OUT"
echo "[ok] SHA256 saved:   $OUT.sha256"

# 8) Inclusion audit (tolerant patterns)
AUDIT_LOG="$BKP_DIR/${OUT_NAME}.audit.txt"
LIST="$(tar -tzf "$OUT")"

has() { echo "$LIST" | grep -Eq "$1"; }

{
  echo "=== Inclusion audit for $OUT_NAME ==="
  echo "Timestamp: $TS"
  echo
  echo "[Expect] Tag root: $TAG"

  # Allow optional ./ prefix and be resilient
  has "(^|.*/)${TAG}/README_.*\\.md$" \
    && echo "  - README_<tag>.md present?    OK" \
    || echo "  - README_<tag>.md present?    WARN: not found"

  has "(^|.*/)${TAG}/notebooks/.*\\.ipynb$" \
    && echo "  - notebooks/*.ipynb present?  OK" \
    || echo "  - notebooks/*.ipynb present?  WARN: none found"

  has "(^|.*/)${TAG}/scripts/.*\\.py$" \
    && echo "  - scripts/*.py present?       OK" \
    || echo "  - scripts/*.py present?       WARN: none found"

  has "(^|.*/)${TAG}/__init__\\.py$" \
    && echo "  - __init__.py at tag root?    OK" \
    || echo "  - __init__.py at tag root?    WARN: not found"

  has "(^|.*/)${TAG}/scripts/__init__\\.py$" \
    && echo "  - scripts/__init__.py?        OK" \
    || echo "  - scripts/__init__.py?        WARN: not found"

  if (( EXPANDED )); then
    has "(^|.*/)environment_specifications(/|$)" \
      && echo "  - environment_specifications/? OK" \
      || echo "  - environment_specifications/? WARN: not included"

    has "(^|.*/)bin(/|$)" \
      && echo "  - bin/?                       OK" \
      || echo "  - bin/?                       WARN: not included"

    # Staging meta (handle absolute-to-relative path strip by tar)
    has "(^|.*/)_staging_[^/]+/backup_meta/validate_env_.*\\.txt$" \
      && echo "  - validate_env output in backup_meta/? OK" \
      || echo "  - validate_env output in backup_meta/? INFO: validate_env not run or produced no files"
  fi

  has "(^|.*/)_staging_[^/]+/backup_meta/firstline_before\\.txt$" \
    && echo "  - firstline audit (before)?   OK" \
    || echo "  - firstline audit (before)?   WARN: not included"

  has "(^|.*/)_staging_[^/]+/backup_meta/firstline_after\\.txt$" \
    && echo "  - firstline audit (after)?    OK" \
    || echo "  - firstline audit (after)?    INFO: not run"

  has "(^|.*/)_staging_[^/]+/backup_meta/sys_capture_status\\.txt$" \
    && echo "  - sys_capture status?         OK" \
    || echo "  - sys_capture status?         INFO: sys_capture not run"

  echo
} > "$AUDIT_LOG"
echo "[ok] Wrote audit: $AUDIT_LOG"

# 9) Clean up staging (the tarball already contains it)
rm -rf "$STAGE"
