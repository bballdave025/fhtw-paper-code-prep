param(
  [string]$RootDir = "$PWD\new_experiment_dir",
  [string[]]$Tags = @("default")
)

# Normalize tags: accept space- or comma-separated, or explicit arrays.
if ($null -ne $Tags) {
  if ($Tags -is [string]) { $Tags = @($Tags) }
  $Tags = (($Tags -join ' ') -split '[,\s]+' | Where-Object { $_ -ne '' }) | Select-Object -Unique
} else {
  $Tags = @('default')
}

# (Optional) quick debug; comment out when not needed
# Write-Host "Tags parsed:" ($Tags -join ', ')

# Ensure root directory exists
if (-not (Test-Path $RootDir)) { New-Item -ItemType Directory -Path $RootDir | Out-Null }

#out###  No helper required; this was just paralleling our CMD pattern,
#out###+ istelf set up to avoid the obstruse `$ >> filename 2>nul`
#out## Create a helper script for touching files
#out#$TouchScript = Join-Path $RootDir "scripts\ps_touch.ps1"
#out#if (-not (Test-Path $TouchScript)) {
#out#  New-Item -ItemType Directory -Path (Split-Path $TouchScript) -Force | Out-Null
#out#  @'
#out#  param([string[]]$Paths)
#out#  foreach ($p in $Paths) {
#out#    $dir = Split-Path -Parent $p
#out#    if (-not (Test-Path $dir)) {
#out#      New-Item -ItemType Directory -Path $dir -Force | Out-Null
#out#    }
#out#    if (-not (Test-Path $p)) {
#out#      New-Item -ItemType File -Path $p -Force | Out-Null
#out#    }
#out#  }
#out#  '@ | Set-Content -LiteralPath $TouchScript -Encoding UTF8
#out#}

# Files to create
$Files = @(
  "README.md",
  "notebooks\00_data_exploration.ipynb",
  "notebooks\01_model_build.ipynb",
  "notebooks\02_training.ipynb",
  "notebooks\03_inference_quick_explore.ipynb",
  "scripts\py_build_model.py",
  "scripts\py_train_model.py",
  "scripts\py_inference.py",
  "scripts\py_utils.py",
  "scripts\build_model.cmd",
  "scripts\train_model.cmd",
  "scripts\inference.cmd",
  "scripts\build_model.ps1",
  "scripts\train_model.ps1",
  "scripts\inference.ps1",
  "scripts\build_model.sh",
  "scripts\train_model.sh",
  "scripts\inference.sh"
)

$UntaggedCommon=(
  "scripts/py_touch.py"
  "scripts/normalize_eol.py"
)

foreach ($tag in $Tags) {
  $TagDir = Join-Path $RootDir $tag

  # Create main directories
  $Dirs = @("notebooks", "datasets", "models", "logs", "scripts", "visualizations", "outputs\csv_logs", "outputs\gradcam_images")
  foreach ($d in $Dirs) { New-Item -ItemType Directory -Path (Join-Path $TagDir $d) -Force | Out-Null }

  # Create files with tag appended to stem
  foreach ($f in $Files) {
    $relpath = Split-Path -Path $f -Parent
    $base    = [System.IO.Path]::GetFileNameWithoutExtension($f)
    $ext     = [System.IO.Path]::GetExtension($f)
    $tagged  = Join-Path -Path (Join-Path -Path $TagDir -ChildPath $relpath) -ChildPath "$base`_$tag$ext"
    #$tagged  = Join-Path $TagDir "$relpath" "$base`_$tag$ext"

    $dir = Split-Path -Parent $tagged
    if (-not (Test-Path $dir)) {
      New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    if (-not (Test-Path $tagged)) {
      New-Item -ItemType File -Path $tagged -Force | Out-Null
    }
  }

  ##-----------------------------------------------------------------
  ##  I _do_ include a couple of per-experiment helpers, written 
  ##+ in Python. The first is in case some kind of `touch' 
  ##+ functionality be desired that's consistent between Windows
  ##+ and Linux (*NIX). The second is an End Of Line Normalizer,
  ##+ a helper-function-version of programs like dos2unix / unix2dos
  ##+ This allows cross-platform creation of an experimental
  ##+ directory very quickly.
  
  # Create (untagged common) py_touch.py if missing
  $PyTouchPath = Join-Path $TagDir "scripts\py_touch.py"
  if (-not (Test-Path $PyTouchPath)) {
    @'
import sys
from pathlib import Path
for f in sys.argv[1:]: Path(f).touch(exist_ok=True)

'@ | Set-Content -Path $PyTouchPath -Encoding UTF8
  }
  
  # Info on the py_touch helper
  Write-Host "  ---------------------------------------------------------"
  Write-Host "  OS-agnostic helper,"
  Write-Host "  $PyTouchPath"
  Write-Host "  provided for tag, '$tag', in case it be desired."
  Write-Host "  This could prove immensely helpful for Windows users."
  Write-Host "  On *NIX, prefer touch(1) when available; this is a fallback."
  Write-Host ""

  # Create (untagged common) normalize_eol.py if missing
  $NormEolPath = Join-Path $TagDir "scripts\normalize_eol.py"
  if (-not (Test-Path $Norm)) {
    @'
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
      > python normalize_eo.py <argument>
    OR
      $ python normalize_eo.py <argument>
  
  """
  
  #  Note that this next call combines calling main, the exiting with
  #+ its return value. I think it's even clearer than assigning the
  #+ return value of main to, say, retval, and then returning retval.
  
  sys.exit(main())

'@ | Set-Content -Path $NormEolPath -Encoding UTF8
  }
  
  # Info on the normalize_eol helper
  Write-Host "  ---------------------------------------------------------"
  Write-Host "  OS-agnostic helper,"
  Write-Host "  $NormEolPath"
  Write-Host "  provided for tag, '$tag'. IT WILL BE NECESSARY TO USE IT!"
  Write-Host "  DO NOT MISS reading the pre-running instructions,"
  Write-Host "  Section ## REQUIRED Pre-running Instructions, to allow"
  Write-Host "  allow the files to run from your repo, whether on your local"
  Write-Host "  machine or on any online/VPN/other machine."
  Write-Host "  THIS IS NECESSARY WHETHER ON WINDOWS OR *NIX!"
  Write-Host "  DO NOT PROCEED FURTHER WITHOUT FOLLOWING THOSE INSTRUCTIONS!"
  Write-Host ""

}

Write-Host "--------------------------------------------------------------------"
Write-Host "Project scaffolding with tags and tag-named subdirectories created at $RootDir"
Write-Host "--------------------------------------------------------------------"
