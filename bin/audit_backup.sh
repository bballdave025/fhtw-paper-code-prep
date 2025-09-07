#!/usr/bin/env bash
# Standalone audit for an existing backup tarball.
# Usage: audit_backup.sh <archive.tar.gz> <tag_path>
set -euo pipefail
OUT="${1:?Usage: $(basename "$0") <archive.tar.gz> <tag>}"
TAG="${2:?tag path e.g. test_project_bash/p_01}"

LIST="$(tar -tzf "$OUT")"
has(){ echo "$LIST" | grep -Eq "$1"; }

report(){
  local label="$1" pat="$2" warn="$3"
  if has "$pat"; then printf "  - %-32s OK\n" "$label"
  else printf "  - %-32s %s\n" "$label" "$warn"
  fi
}

echo "=== Quick audit for $(basename "$OUT") ==="
report "README_<tag>.md present?" "(^|.*/)${TAG}/README_.*\\.md$" "WARN: not found"
report "notebooks/*.ipynb present?" "(^|.*/)${TAG}/notebooks/.*\\.ipynb$" "WARN: none found"
report "scripts/*.py present?" "(^|.*/)${TAG}/scripts/.*\\.py$" "WARN: none found"
report "__init__.py at tag root?" "(^|.*/)${TAG}/__init__\\.py$" "WARN: not found"
report "scripts/__init__.py?" "(^|.*/)${TAG}/scripts/__init__\\.py$" "WARN: not found"
report "env specs included?" "(^|.*/)environment_specifications(/|$)" "WARN: not included"
report "bin/ included?" "(^|.*/)bin(/|$)" "WARN: not included"
report "firstline audit (before)?" "(^|.*/)_staging_[^/]+/backup_meta/firstline_before\\.txt$" "WARN: not included"
report "firstline audit (after)?" "(^|.*/)_staging_[^/]+/backup_meta/firstline_after\\.txt$" "INFO: not run"
report "validate_env output?" "(^|.*/)_staging_[^/]+/backup_meta/validate_env_.*\\.txt$" "INFO: validate_env not run"
report "sys_capture status?" "(^|.*/)_staging_[^/]+/backup_meta/sys_capture_status\\.txt$" "INFO: sys_capture not run"
