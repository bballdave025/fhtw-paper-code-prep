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
      > python normalize_eol.py <argument>
    OR
      $ python normalize_eol.py <argument>
  
  """
  
  #  Note that this next call combines calling main, the exiting with
  #+ its return value. I think it's even clearer than assigning the
  #+ return value of main to, say, retval, and then returning retval.
  
  sys.exit(main())

