\
#!/usr/bin/env bash
# sys_capture.sh
# Capture env + system + git state for a run.
#
# Defaults target a project-level logs dir:
#   $PROJECT_ROOT/logs/system_<stamp>/
# You can override to a tag-specific location with --tag p_01 (then $PROJECT_ROOT/test_project_bash/p_01/logs/...)
#
# Usage:
#   sys_capture.sh [--project ROOT] [--tag TAGDIR_NAME] [--out-root DIR] [--note TEXT]
#                  [--no-git] [--no-conda-lock] [--no-pip-freeze] [--json-only]
#
# Examples:
#   sys_capture.sh --project "$HOME/my_repos_dwb/fhtw-paper-code-prep"
#   sys_capture.sh --project "$PWD" --tag p_01 --note "seed=137 try1"
#   RUN_ID="p_01_try_$(date +'%Y-%m-%dT%H%M%S%z')" sys_capture.sh --project "$PWD" --tag p_01
#
set -Eeuo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-}"
TAG_NAME=""
OUT_ROOT=""
NOTE=""
DO_GIT=1
DO_CONDA_LOCK=1
DO_PIP_FREEZE=1
JSON_ONLY=0

usage() {
  sed -n '1,40p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

# --- parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--project) PROJECT_ROOT="$2"; shift 2;;
    -t|--tag) TAG_NAME="$2"; shift 2;;
    -o|--out-root) OUT_ROOT="$2"; shift 2;;
    -n|--note) NOTE="$2"; shift 2;;
    --no-git) DO_GIT=0; shift;;
    --no-conda-lock) DO_CONDA_LOCK=0; shift;;
    --no-pip-freeze) DO_PIP_FREEZE=0; shift;;
    --json-only) JSON_ONLY=1; shift;;
    -h|--help) usage;;
    *) echo "Unknown option: $1" >&2; usage;;
  esac
done

# --- resolve project root ---
if [[ -z "${PROJECT_ROOT}" ]]; then
  # auto-detect by looking for repo markers
  if [[ -f "./README.md" && -d "./test_project_bash" ]]; then
    PROJECT_ROOT="$(pwd)"
  elif [[ -d "../test_project_bash" ]]; then
    PROJECT_ROOT="$(cd .. && pwd)"
  else
    PROJECT_ROOT="$(pwd)"  # fallback
  fi
fi

# --- compute base output dir ---
STAMP="${RUN_ID:-$(date +'%s_%Y-%m-%dT%H%M%S%z')}"
if [[ -n "${OUT_ROOT}" ]]; then
  BASE_OUT="${OUT_ROOT}"
elif [[ -n "${TAG_NAME}" ]]; then
  BASE_OUT="${PROJECT_ROOT}/test_project_bash/${TAG_NAME}/logs"
else
  BASE_OUT="${PROJECT_ROOT}/logs"
fi
OUT="${BASE_OUT}/system_${STAMP}"
mkdir -p -- "$OUT"

echo "→ Capturing to: $OUT"

# --- 1) Git snapshot ---
if (( DO_GIT )); then
  if command -v git >/dev/null 2>&1; then
    git -C "$PROJECT_ROOT" rev-parse HEAD > "$OUT/git_commit.txt" 2>/dev/null || true
    git -C "$PROJECT_ROOT" status --porcelain=v1 > "$OUT/git_status.txt" 2>/dev/null || true
    git -C "$PROJECT_ROOT" diff > "$OUT/git_diff.patch" 2>/dev/null || true
  fi
fi

# --- 2) Conda/Python/env ---
if command -v conda >/dev/null 2>&1; then
  conda info > "$OUT/conda_info.txt" 2>/dev/null || true
  conda env export --from-history > "$OUT/environment.yml" 2>/dev/null || true
  if (( DO_CONDA_LOCK )); then
    conda list --explicit > "$OUT/conda-linux-64.lock" 2>/dev/null || true
  fi
fi
python -V > "$OUT/python_version.txt" 2>/dev/null || true
if (( DO_PIP_FREEZE )); then
  python -m pip freeze > "$OUT/requirements.txt" 2>/dev/null || true
fi
jupyter kernelspec list > "$OUT/kernelspecs.txt" 2>/dev/null || true

# --- 3) System snapshot ---
uname -a > "$OUT/uname.txt" 2>/dev/null || true
( command -v lsb_release >/dev/null && lsb_release -a ) > "$OUT/lsb_release.txt" 2>/dev/null || true
( command -v lscpu >/dev/null && lscpu ) > "$OUT/lscpu.txt" 2>/dev/null || true
( command -v free >/dev/null && free -h ) > "$OUT/mem.txt" 2>/dev/null || true
( command -v df  >/dev/null && df -hP . ) > "$OUT/disk.txt" 2>/dev/null || true

# --- 4) GPU snapshot (non-fatal) ---
( command -v nvidia-smi >/dev/null && nvidia-smi -q ) > "$OUT/nvidia_smi.txt" 2>/dev/null || true

# --- 5) Structured JSON summary (Python) ---
python - <<'PY' > "$OUT/system_info.json" 2>/dev/null || true
import json, sys, platform, os, subprocess
def cmd(args):
    try: return subprocess.check_output(args, text=True).strip()
    except Exception: return None
info = {
  "python": cmd([sys.executable, "--version"]),
  "platform": platform.platform(),
  "uname": dict(zip(("system","node","release","version","machine","processor"),
                    platform.uname())),
  "conda_prefix": os.environ.get("CONDA_PREFIX"),
  "git_commit": cmd(["git","rev-parse","HEAD"]),
}
try:
    import tensorflow as tf; info["tensorflow"] = tf.__version__
except Exception: pass
try:
    import numpy as np; info["numpy"] = np.__version__
except Exception: pass
print(json.dumps(info, indent=2))
PY

# --- 6) Optional human note ---
if [[ -n "${NOTE}" ]]; then
  printf "%s\n" "$NOTE" > "$OUT/note.txt"
fi

# --- 7) Minimal mode: keep only JSON if requested ---
if (( JSON_ONLY )); then
  find "$OUT" -type f ! -name 'system_info.json' -delete
fi

echo "✓ Capture complete: $OUT"
