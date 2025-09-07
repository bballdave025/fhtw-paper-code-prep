#!/usr/bin/env bash

# --- ALF_EARLY_CHECK_HOOK: inserted by apply_local_fixes.sh ---
if [ "${1:-}" = "--check" ]; then
  set -euo pipefail
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  TAGDIR_LOCAL="${TAGDIR:-$ROOT}"
  TAG_LOCAL="${TAG:-$(basename "$TAGDIR_LOCAL")}"
  missing=0
  cd "$ROOT"
  say(){ printf "%s\n" "$*"; }
  for p in datasets outputs outputs/csv_logs scripts notebooks; do
    [ -e "$p" ] || { say "MISSING: $p"; missing=1; }
  done
  PY_UTIL="scripts/py_utils_${TAG_LOCAL}.py"
  NB="notebooks/02_training_${TAG_LOCAL}.ipynb"
  [ -e "$PY_UTIL" ] || { say "MISSING: $PY_UTIL"; missing=1; }
  [ -e "$NB" ] || { say "MISSING: $NB"; missing=1; }
  exit $missing
fi
# --- end ALF_EARLY_CHECK_HOOK ---
# Usage:                 ./structure.sh <ROOT_DIR> <tag1> [tag2 ...]
#   OR
#        WITH_NB_STUBS=1 ./structure.sh <ROOT_DIR> <tag1> [tag2 ...]
#
# Creates the structure shown in your example, including:
# - README_<tag>.md
# - notebooks/*_<tag>.ipynb
#   - (Note that these are created idempotently, i.e. the are created
#      only if they do not already exist. If  WITH_NB_STUBS=1  is
#      included, minimal IPYNB files, i.e. those with enough JSON
#      content to be recognized as IPYNB files, will be created,
#      once again idempotently)
# - scripts/{py_build_model,py_train_model,py_inference,py_utils}_<tag>.py
# - scripts/{build_model,train_model,inference}_<tag>.cmd
# - scripts/py_touch.py        # untagged (per tag directory)
# - datasets/, models/, logs/, visualizations/, 
#   outputs/{csv_logs,gradcam_images}
#
#
#
#
# As far as the backup subcommand, some examples follow
#
# # Back up a single tag (tight)
# ./structure.sh backup "$HOME/my_repos_dwb/fhtw-paper-code-prep" test_project_bash/p_01
#
# # Expanded + apply firstline fixes (after audit)
# ./structure.sh backup "$HOME/my_repos_dwb/fhtw-paper-code-prep" test_project_bash/p_01 --expanded --fix-firstline
#
# # Multiple tags, expanded, no system snapshot
# ./structure.sh backup "$HOME/my_repos_dwb/fhtw-paper-code-prep" test_project_bash/p_01 test_project_bash/p_03_e2e --expanded --skip-sys
#
#


set -euo pipefail

# ---- usage/help (robust, multi-line) ----
usage() {
  cat <<EOF
Usage:
  $0 <ROOT_DIR> <tag1> [tag2 ...]

Optionally:
  WITH_NB_STUBS=1 $0 <ROOT_DIR> <tag1> [tag2 ...]

Creates the scaffold; if WITH_NB_STUBS=1, also creates minimal .ipynb stubs.
Idempotent (won’t clobber existing files).

Subcommands:
  $0 backup <ROOT_DIR> <tag1> [tag2 ...] [--expanded] [--fix-firstline] [--skip-sys] [--skip-nbs]
    Runs bin/backup_everything.sh for each tag. Leaves scaffolding untouched.
EOF
}

# ---- backup subcommand passthrough ----
do_backup_subcommand() {
  # Usage: structure.sh backup <ROOT_DIR> <tag1> [tag2 ...] [flags...]
  # Flags are forwarded to bin/backup_everything.sh
  local _args=("$@")
  if (( ${#_args[@]} < 2 )); then
    echo "Usage: $0 backup <ROOT_DIR> <tag1> [tag2 ...] [--expanded] [--fix-firstline] [--skip-sys] [--skip-nbs]" >&2
    exit 2
  fi

  local _root="${_args[0]}"; shift || true
  # collect tags until a flag (starts with --)
  local _tags=()
  while (( $# )) && [[ "${1}" != --* ]]; do
    _tags+=("$1"); shift
  done
  local _flags=("$@")

  # Ensure backup script exists
  local _bkpsh="$_root/bin/backup_everything.sh"
  if [[ ! -x "$_bkpsh" ]]; then
    echo "[ERR] Not found or not executable: $_bkpsh" >&2
    echo "      Please place backup_everything.sh in \$_ROOT/bin and chmod +x." >&2
    exit 1
  fi

  # Run for each tag
  for t in "${_tags[@]}"; do
    echo "==> Backing up tag: $t"
    "$_bkpsh" "$_root" "$t" "${_flags[@]}"
    echo
  done
  exit 0
}

#old#ROOT_DIR="${1:?Usage:"\
#old#"                                  $0 <ROOT_DIR> <tag1> [tag2 ...]\n"\
#old#" (optionally) run WITH_NB_STUBS=1 $0 <ROOT_DIR> <tag1> [tag2 ...]\n"\
#old#" The second creates minimal IPYNB files. Both create IPYNB idempotently i.e.\n"\
#old#" only if they do not exist.}"

if (( $# < 2 )); then usage >&2; exit 1; fi

# Subcommand: backup
if [[ "${1:-}" == "backup" ]]; then
  shift
  do_backup_subcommand "$@"
fi

# ---- args/derived ----
ROOT_DIR=$1; shift
if [ $# -lt 1 ]; then
  echo "Need at least one tag (e.g., p_01 p_02)" >&2
  exit 2
fi
TAGS=("$@")

#  Untagged/common base (defaults to ROOT_DIR, can be overridden by env
: "${UNTAGGED_COMMON:="$ROOT_DIR"}"

# Common per-tag untagged helper
UNTAGGED_COMMON_FILES=(
  "scripts/py_touch.py"
  "scripts/normalize_eol.py"
  #".gitattributes"
)

#  Put EOL entries in for platform-specific files,
#+  thus ensuring platform independence
ensure_gitattributes_entries() {
  local base="${1:-$ROOT_DIR}"
  local repo_root
  repo_root=$(git -C "$base" rev-parse --show-toplevel 2>/dev/null || echo "$base")

  local f="$repo_root/.gitattributes"
  local -a lines=(
    "*.sh              text eol=lf"
    "*.ps1             text eol=crlf"
    "*.cmd             text eol=crlf"
    "*.py              text eol=lf"
    "*.md              text eol=lf"
    "*.ipynb           text eol=lf"
    ".gitattributes    text eol=lf"
  )

  mkdir -p "$repo_root"
  touch "$f"
  chmod 0644 "$f" 2>/dev/null || true
  # ensure file ends with newline
  tail -c1 "$f" 2>/dev/null | grep -q $'\n' || echo >> "$f"

  for line in "${lines[@]}"; do
    grep -Fqx -- "$line" "$f" || echo "$line" >> "$f"
  done
  echo "[OK] ensured .gitattributes entries at $f"
}

mkd() { mkdir -p -- "$1"; }
touch_safe() {
  local path="$1"
  mkd "$(dirname -- "$path")"
  [ -f "$path" ] || : > "$path"
}

#@TODO : Use getopt to pass in the WITH_NB_STUBS option as well as other opts
#
#  Optional: export WITH_NB_STUBS=1 to write minimal *.ipynb files
WITH_NB_STUBS="${WITH_NB_STUBS:-0}"
emit_ipynb() {
  local path="$1"
  python - <<'PY' "$path"
import json, sys, os
nb = {
  "cells":[{"cell_type":"code","execution_count":None,"metadata":{},"outputs":[],
    "source":[
      "import os, random, numpy as np, tensorflow as tf\n",
      "os.environ[\"PYTHONHASHSEED\"]=\"137\";\n",
      "random.seed(137);\n",
      "np.random.seed(137);\n",
      "tf.random.set_seed(137)\n"
    ]}],
  "metadata":{
    "kernelspec":{"display_name":"Python 3 (ipykernel)","language":"python","name":"python3"},
    "language_info":{"name":"python","version":"3.10"}
  },
  "nbformat":4,"nbformat_minor":5
}
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(nb, ensure_ascii=False, indent=1))
PY
}

## Added 1756960018_2025-09-03T222658-0600, just barely
if [ ! -d "$ROOT_DIR" ]; then
  mkd "$ROOT_DIR"
fi

ensure_gitattributes_entries "$ROOT_DIR"

echo "  have this in here."
echo "  (Note that any files that should be excluded/ignored"
echo "   are covered in the Git repo's root .gitignore file.)"
echo

# Per-tag file stems (relative to the tag root)
README_STEM="README.md"

#  Per-tag enabling import of tag-dir  and its script dir as packages
#+ tag is NOT part of filename
PACKAGE_FILES=(
  "__init__.py"
  "scripts/__init__.py"
)

# Notebooks (placed under notebooks/, with tag suffix)
NB_FILES=(
  "notebooks/00_data_exploration.ipynb"
  "notebooks/01_model_build.ipynb"
  "notebooks/02_training.ipynb"
  "notebooks/03_inference_quick_explore.ipynb"
)

#  Scripts (tag-suffixed python placeholders)
#+ These could perform the same thing as the
#+ *.sh versions and the *.ps1 versions. 
#+ We'll probably only get to one of them
#+ before the Fragmentology publication.
PY_FILES=(
  "scripts/py_build_model.py"
  "scripts/py_train_model.py"
  "scripts/py_inference.py"
  "scripts/py_utils.py"
)

#  Scripts (tag-suffixed SH placeholders)
#+ These could perform the same thing as the
#+ py_*.py versions and the *.ps1 versions. 
#+ We'll probably only get to one of them
#+ before the Fragmentology publication.
THE_SH_FILES=(
  "scripts/build_model.sh"
  "scripts/train_model.sh"
  "scripts/inference.sh"
  "scripts/py_utils.sh"
)

#  Scripts (tag-suffixed SH placeholders)
#+ These could perform the same thing as the
#+ py_*.py versions and the *.ps1 versions. 
#+ We'll probably only get to one of them
#+ before the Fragmentology publication.
THE_PS_FILES=(
  "scripts/build_model.ps1"
  "scripts/train_model.ps1"
  "scripts/inference.ps1"
)

#  Scripts (tag-suffixed CMD placeholders)
#+ We probably won't ever end up touching
#+ these, but they're here for completeness.
CMD_FILES=(
  "scripts/build_model.cmd"
  "scripts/train_model.cmd"
  "scripts/inference.cmd"
)

# Fixed directory set under each tag
DIRS=(
  "notebooks"
  "datasets"
  "models"
  "logs"
  "visualizations"
  "scripts"
  "outputs/csv_logs"
  "outputs/gradcam_images"
)

for tag in "$@"; do
  TAG_DIR="${ROOT_DIR%/}/$tag"

  # Directories
  for d in "${DIRS[@]}"; do
    mkd "$TAG_DIR/$d"
  done

  # README_<tag>.md at tag root
  touch_safe "$TAG_DIR/${README_STEM%.md}_${tag}.md"
  
  #  __init__.py files needed for import (create proper packages out of dirs)
  #+ tag is NOT part of filename
  for f in "${PACKAGE_FILES[@]}"; do
    touch_safe "$TAG_DIR/$f"
    # Info on the __init__.py helper
    echo "  ---------------------------------------------------------"
    echo "  First OS-agnostic Python helper, __init__.py"
    echo "  provided for tag, ``tag' at"
    echo "  '$TAG_DIR/$f'"
    echo "  to allow the directory name to serve as a package name,"
    echo "  simplifying imports."
    echo
  done

  # Notebooks with _<tag>.ipynb inside notebooks/
  for f in "${NB_FILES[@]}"; do
    base="$(basename -- "$f")"
    stem="${base%.*}"
    ext="${base##*.}"
    dst="$TAG_DIR/notebooks/${stem}_${tag}.${ext}"
    if [ "$WITH_NB_STUBS" = "1" ]; then
      [ -f "$dst" ] || emit_ipynb "$dst"
    else
      touch_safe "$dst"
    fi
  done

  # Python scripts with _<tag>.py
  for f in "${PY_FILES[@]}"; do
    base="$(basename -- "$f")"
    stem="${base%.*}"
    ext="${base##*.}"
    touch_safe "$TAG_DIR/scripts/${stem}_${tag}.${ext}"
  done

  # CMD placeholders with _<tag>.cmd
  for f in "${CMD_FILES[@]}"; do
    base="$(basename -- "$f")"
    stem="${base%.*}"
    ext="${base##*.}"
    touch_safe "$TAG_DIR/scripts/${stem}_${tag}.${ext}"
  done

  # PowerShell placeholders with _<tag>.ps1
  for f in "${THE_PS_FILES[@]}"; do
    base="$(basename -- "$f")"
    stem="${base%.*}"
    ext="${base##*.}"
    touch_safe "$TAG_DIR/scripts/${stem}_${tag}.${ext}"
  done
  
  # SH placeholders with _<tag>.cmd
  for f in "${THE_SH_FILES[@]}"; do
    base="$(basename -- "$f")"
    stem="${base%.*}"
    ext="${base##*.}"
    touch_safe "$TAG_DIR/scripts/${stem}_${tag}.${ext}"
  done
  
  # Untagged common helpers
  for f in "${UNTAGGED_COMMON_FILES}"; do
    touch_safe "$TAG_DIR/$f"
  done
  
  
  ##-----------------------------------------------------------------
  ##  I do include a couple of per-experiment helpers, written 
  ##+ in Python. The first is in case some kind of `touch' 
  ##+ functionality be desired that's consistent between Windows
  ##+ and Linux (*NIX). The second is an End Of Line Normalizer,
  ##+ a helper-function-version of programs like dos2unix / unix2dos
  ##+ This allows cross-platform creation of an experimental
  ##+ directory very quickly.
  
  ##  The idea of a `touch'-like function for PowerShell was
  ##+ abandoned. I _do_ include a per-experiment helper, written
  ##+ in Python, the "first" explained above.
  
  py_touch_path="$TAG_DIR/scripts/py_touch.py"
  if [ ! -f "$py_touch_path" ]; then
    cat << 'EOF' > "$py_touch_path"
import sys
from pathlib import Path
for f in sys.argv[1:]: Path(f).touch(exist_ok=True)
EOF

  fi
  
  # Info on the py_touch helper
  echo "  ---------------------------------------------------------"
  echo "  OS-agnostic helper,"
  echo "  $py_touch_path"
  echo "  This could prove immensely helpful for Windows users."
  echo "  On *NIX, prefer touch(1) when available; this is a fallback."
  echo
  
  # Create (untagged-common) normalize_eol.py if missing
  norm_eol_path="$TAG_DIR/scripts/normalize_eol.py"
  if [ ! -f "$norm_eol_path" ]; then
    cat << 'EONormF' > "$norm_eol_path"
"""
Normalize line endings (EOL) for text files.

Usage modes:
  A) By extension map (recommended)
     python normalize_eol.py --root <DIR> --map sh=lf,ps1=crlf,cmd=crlf,py=lf,ipynb=lf,md=lf

  B) Explicit mode on listed files
     python normalize_eol.py --to-lf  file1 file2 ...
     python normalize_eol.py --to-crlf file1 file2 ...

Notes:
  - Skips binaries by a simple heuristic (NULL byte check).
  - Only rewrites when a change is needed.
"""

import argparse, os, sys
from pathlib import Path

def is_binary(data: bytes) -> bool:
  """
  Heuristic: treat as binary if there is a NUL byte.
  """
  return b"\x00" in data

def normalize_bytes(data: bytes, mode: str) -> bytes:
  """
  Convert EOLs:
    mode=''lf''   -> \n
    mode=''crlf'' -> \r\n
  """
  # First unify to LF
  text = data.replace(b"\r\n", b"\n").replace(b"\r", b"\n")
  if mode == "lf":
    return text
  elif mode == "crlf":
    return text.replace(b"\n", b"\r\n")
  else:
    raise ValueError(f"Unknown mode: {mode}")

def normalize_file(path: Path, mode: str) -> bool:
  """
  Normalize a single file in-place. Returns True if modified.
  """
  try:
    raw = path.read_bytes()
  except Exception:
    return False
  if is_binary(raw):
    return False
  new = normalize_bytes(raw, mode)
  if new != raw:
    path.write_bytes(new)
    return True
  return False

def parse_map(map_str: str) -> dict:
  """
  Parse ''ext=mode,ext=mode'' into dict like {''.sh'':''lf'', ''.ps1'':''crlf''}
  """
  out = {}
  for part in map_str.split(","):
    part = part.strip()
    if not part:
      continue
    k, v = part.split("=")
    ext = k.strip().lower()
    if not ext.startswith("."):
      ext = "." + ext
    out[ext] = v.strip().lower()
  return out

def normalize_by_map(root: Path, extmap: dict) -> int:
  """
  Walk root and apply per-extension modes. Returns count of modified files.
  """
  n = 0
  for p in root.rglob("*"):
    if not p.is_file():
      continue
    mode = extmap.get(p.suffix.lower())
    if not mode:
      continue
    if normalize_file(p, mode):
      n += 1
  return n

def main(argv=None):
  """
  CLI entry point.
  """
  ap = argparse.ArgumentParser()
  g = ap.add_mutually_exclusive_group()
  g.add_argument("--to-lf",   action="store_true", help="Force LF on listed files")
  g.add_argument("--to-crlf", action="store_true", help="Force CRLF on listed files")
  ap.add_argument("--root", type=Path, help="Directory to normalize recursively")
  ap.add_argument("--map",  type=str, help="Extension map like ''sh=lf,ps1=crlf''")
  ap.add_argument("files", nargs="*", type=Path, help="Files to normalize (with --to-*)")
  args = ap.parse_args(argv)

  # Mode B: explicit files
  if args.to_lf or args.to_crlf:
    mode = "lf" if args.to_lf else "crlf"
    changed = 0
    for f in args.files:
      if normalize_file(f, mode):
        changed += 1
    print(f"Changed {changed} files.")
    return 0

  # Mode A: by-extension map under --root
  if args.root and args.map:
    extmap = parse_map(args.map)
    changed = normalize_by_map(args.root, extmap)
    print(f"Changed {changed} files under {args.root}.")
    return 0

  ap.error("Provide either (--to-lf|--to-crlf files...) or --root DIR --map ext=mode,...")

if __name__ == "__main__":
  """
  Gets called if the module is called from command prompt, via
    e.g.
      > python normalize_eof.py <argument>
    OR
      $ python normalize_eof.py <argument>
  
  """
  
  #  Note that this next call combines calling main, the exiting with
  #+ its return value. I think it's even clearer than assigning the
  #+ return value of main to, say, retval, and then returning retval.
  
  sys.exit(main())

EONormF

  fi
  
  # Info on the normalize_eof helper
  echo "  ---------------------------------------------------------"
  echo "  OS-agnostic helper,"
  echo "  $norm_eol_path"
  echo "  DO NOT MISS reading the pre-running instructions, in the $tag"
  echo "  README at Section: REQUIRED Pre-running Instructions, to allow"
  echo "  allow the files to run from your repo, whether on your local"
  echo "  machine or on any online/VPN/other machine."
  echo "  THIS IS NECESSARY WHETHER ON WINDOWS OR *NIX!"
  echo "  DO NOT PROCEED FURTHER WITHOUT FOLLOWING THOSE INSTRUCTIONS!"
  echo
  echo "  From bash, usage should be"
  echo "    \$ python \"\$TAG_DIR/scripts/normalize_eol.py \\\""
  echo "         --root \"\$TAG_DIR\" \\\""
  echo "         --map 'sh=lf,ps1=crlf,cmd=crlf,py=lf,ipynb=lf,md=lf' "
  echo
  echo "  From PowerShell, usage should be"
  echo "    PS> & python \"<path-to-tagdir>\\scripts\\normalize_eol.py\" --root <path-to-tagdir> --map \"sh=lf,ps1=crlf,cmd=crlf,py=lf,ipynb=lf,md=lf\""
  echo "  where <path-to-tagdir> is analogous to"
  echo "  \"$TAG_DIR\" in the Windows platform setup."
  echo 
  

  ##  .gitattributes content now added with ensure_gitattributes_entries
  ##+ function, where it is created/appended at the root of the git repo
  ##+ (if there is a git repo)
#b4#  # Create (untagged-common) .gitattributes (or append if already exists)
#b4#
#b4#    #  .gitattributes addition (or creation) for ease in using
#b4#    #+ platform-specific files (making it platform-agnostic)
#b4#*.sh              text eol=lf
#b4#*.ps1             text eol=crlf
#b4#*.cmd             text eol=crlf
#b4#*.py              text eol=lf
#b4#*.md              text eol=lf
#b4#*.ipynb           text eol=lf
#b4#.gitattributes    text eol=lf
#b4#
#b4#EOGitAttrF
#b4#
#b4#    # Info on the .gitattributes additions (creation)
#b4#    echo "  ---------------------------------------------------------"
#b4#    echo "  Helper to ensure correct EOL on OS-specific files,"
#b4#    echo "  to be stress-free platform-agnostic. Only used"
#b4#    echo "  when things are done in a project where source"
#b4#    echo "  control is handled via Git, but it doesn't hurt to"
#b4#    echo "  have this in here."
#b4#    echo "  (Note that any files that should be excluded/ignored"
#b4#    echo "   are covered in the Git repo's root .gitignore file.)"
#b4#    echo
#b4#  
#b4#  fi

done

echo "--------------------------------------------------------------------"
echo "Project scaffolding with tags for files and tag-named subdirectories created at $ROOT_DIR"
echo "--------------------------------------------------------------------"

# --- injected by apply_local_fixes.sh ---
if [ "${1:-}" = "--check" ]; then
  missing=0
  say() { printf "%s\n" "$*"; }
  TAGDIR_LOCAL="${TAGDIR:-$PWD}"
  TAG_LOCAL="${TAG:-$(basename "$TAGDIR_LOCAL")}"

  for p in "datasets" "outputs" "outputs/csv_logs" "scripts" "notebooks"; do
    [ -e "$p" ] || { say "MISSING: $p"; missing=1; }
  done

  PY_UTIL="scripts/py_utils_${TAG_LOCAL}.py"
  NB="notebooks/02_training_${TAG_LOCAL}.ipynb"
  [ -e "$PY_UTIL" ] || { say "MISSING: $PY_UTIL"; missing=1; }
  [ -e "$NB" ] || { say "MISSING: $NB"; missing=1; }

  exit $missing
fi
# --- end injected ---
