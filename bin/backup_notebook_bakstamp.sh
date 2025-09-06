#!/usr/bin/env bash
# backup_notebook_bakstamp.sh
# Create timestamped .bak copies of one or more notebooks in-place.
# Usage: backup_notebook_bakstamp.sh NOTEBOOK.ipynb [MORE.ipynb ...]
# Pattern: file.ipynb.$(date +'%s_%Y-%m-%dT%H%M%S%z').bak

set -Eeuo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename "$0") NOTEBOOK.ipynb [MORE.ipynb ...]" >&2
  exit 2
fi

stamp="$(date +'%s_%Y-%m-%dT%H%M%S%z')"

for nb in "$@"; do
  if [[ ! -f "$nb" ]]; then
    echo "Skipping non-existent: $nb" >&2
    continue
  fi
  dir="$(dirname "$nb")"
  base="$(basename "$nb")"
  bak="${dir}/${base}.${stamp}.bak"
  cp -v -- "$nb" "$bak"
done
