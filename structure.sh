#!/usr/bin/env bash
# Usage: ./structure.sh <ROOT_DIR> <tag1> [tag2 ...]
# Creates the structure shown in your example, including:
# - README_<tag>.md
# - notebooks/*_<tag>.ipynb
# - scripts/{py_build_model,py_train_model,py_inference,py_utils}_<tag>.py
# - scripts/{build_model,train_model,inference}_<tag>.cmd
# - scripts/py_touch.py        # untagged (per tag directory)
# - datasets/, models/, logs/, visualizations/, outputs/{csv_logs,gradcam_images}

set -euo pipefail

ROOT_DIR="${1:?Usage: $0 <ROOT_DIR> <tag1> [tag2 ...]}"
shift
if [ $# -lt 1 ]; then
  echo "Need at least one tag (e.g., p_01 p_02)" >&2
  exit 2
fi

mkd() { mkdir -p -- "$1"; }
touch_safe() {
  local path="$1"
  mkd "$(dirname -- "$path")"
  [ -f "$path" ] || : > "$path"
}

# Per-tag file stems (relative to the tag root)
README_STEM="README.md"

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

# Common per-tag untagged helper
UNTAGGED_COMMON_FILES=(
  "scripts/py_touch.py"
  "scripts/normalize_eol.py"
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

  # Notebooks with _<tag>.ipynb inside notebooks/
  for f in "${NB_FILES[@]}"; do
    base="$(basename -- "$f")"
    stem="${base%.*}"
    ext="${base##*.}"
    touch_safe "$TAG_DIR/notebooks/${stem}_${tag}.${ext}"
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
  for f in "${UNTAGGED_COMMON}"
    touch_safe "$TAG_DIR/$f"
  
  
  "scripts/py_touch.py"
  "scripts/normalize_eol.py"
  
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
  
  #Info on the py_touch helper
  echo "  ---------------------------------------------------------"
  echo "  OS-agnostic helper,"
  echo "  $py_touch_path"
  echo "  provided for tag, ``$tag', in case it be desired."
  echo "  This could prove immensely helpful for Windows users."
  echo "  On *NIX-type systems, I suggest using ``touch(1)', unless"
  echo "  it be not installed, e.g. unless you have only the base"
  echo "  installation."
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
  
  #Info on the normalize_eof helper
  echo "  ---------------------------------------------------------"
  echo "  OS-agnostic helper,"
  echo "  $NormEolPath"
  echo "  provided for tag, '$tag'. IT WILL BE NECESSARY TO USE IT!"
  echo "  DO NOT MISS reading the pre-running instructions, in the $tag"
  echo "  README at Section: REQUIRED Pre-running Instructions, to allow"
  echo "  allow the files to run from your repo, whether on your local"
  echo "  machine or on any online/VPN/other machine."
  echo "  THIS IS NECESSARY WHETHER ON WINDOWS OR *NIX!"
  echo "  DO NOT PROCEED FURTHER WITHOUT FOLLOWING THOSE INSTRUCTIONS!"
  echo
  
done

echo "--------------------------------------------------------------------"
echo "Project scaffolding with tags for files and tag-named subdirectories created at $ROOT_DIR"
echo "--------------------------------------------------------------------"
