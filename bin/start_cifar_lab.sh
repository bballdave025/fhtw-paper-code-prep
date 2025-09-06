#!/usr/bin/env bash
# start_cifar_lab.sh
# Helper to cd into your CIFAR-10 project tag directory, activate env, and launch JupyterLab.

set -Eeuo pipefail

PROJECT_DIR="${PROJECT_DIR:-$HOME/my_repos_dwb/fhtw-paper-code-prep/test_project_bash/p_01}"
ENV_NAME="${ENV_NAME:-vanillacnn}"
NO_BROWSER="${NO_BROWSER:-0}"
PORT="${PORT:-8888}"
ENSURE_KERNEL="${ENSURE_KERNEL:-0}"
KERNEL_NAME="${KERNEL_NAME:-vanillacnn}"
KERNEL_DISPLAY="${KERNEL_DISPLAY:-Python (vanillacnn)}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") [options]

Options:
  -p, --project DIR      Project tag directory (default: \$HOME/my_repos_dwb/fhtw-paper-code-prep/test_project_bash/p_01)
  -e, --env NAME         Conda environment name (default: vanillacnn)
  -k, --ensure-kernel    Ensure ipykernel is registered for this env (default: off)
  -b, --no-browser       Launch JupyterLab without opening a browser (default: off)
  -P, --port PORT        Jupyter port (default: 8888)
  -h, --help             Show this help and exit
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--project) PROJECT_DIR="$2"; shift 2;;
    -e|--env) ENV_NAME="$2"; shift 2;;
    -k|--ensure-kernel) ENSURE_KERNEL="1"; shift;;
    -b|--no-browser) NO_BROWSER="1"; shift;;
    -P|--port) PORT="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown option: $1" >&2; usage; exit 2;;
  esac
done

# Init conda or micromamba
if command -v conda >/dev/null 2>&1; then
  eval "$(conda shell.bash hook)"
  if ! conda activate "$ENV_NAME" 2>/dev/null; then
    echo "Conda env '$ENV_NAME' not found." >&2
    echo "Create it, e.g." >&2
    echo "  conda create -n $ENV_NAME --file $HOME/my_repos_dwb/fhtw-paper-code-prep/environment_specifications/conda-linux-64.lock" >&2
    echo "OR possibly" >&2
    echo "  conda create -n $ENV_NAME --file conda-linux-64.lock" >&2
    exit 1
  fi
elif command -v micromamba >/dev/null 2>&1; then
  eval "$(micromamba shell hook -s bash)"
  if ! micromamba activate "$ENV_NAME" 2>/dev/null; then
    echo "Micromamba env '$ENV_NAME' not found." >&2
    echo "Create it, e.g." >&2
    echo "   micromamba create -n $ENV_NAME --file $HOME/my_repos_dwb/fhtw-paper-code-prep/environment_specifications/conda-linux-64.lock" >&2
    echo "OR possibly" >&2
    echo "   micromamba create -n $ENV_NAME --file conda-linux-64.lock" >&2
    exit 1
  fi
else
  echo "Error: Neither conda nor micromamba found on PATH." >&2
  exit 1
fi

# Optional: ensure kernel
if [[ "${ENSURE_KERNEL}" == "1" ]]; then
  python - <<PY
import subprocess, sys
try:
    import jupyter_client  # noqa
except Exception:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "ipykernel"])
subprocess.check_call([sys.executable, "-m", "ipykernel", "install", "--user",
                       "--name", "${KERNEL_NAME}", "--display-name", "${KERNEL_DISPLAY}"])
print("Kernel ensured: ${KERNEL_DISPLAY}")
PY
fi

cd "$PROJECT_DIR"

if command -v jupyter-lab >/dev/null 2>&1; then
  if [[ "$NO_BROWSER" == "1" ]]; then
    exec jupyter-lab --no-browser --port "$PORT"
  else
    exec jupyter-lab --port "$PORT"
  fi
else
  if [[ "$NO_BROWSER" == "1" ]]; then
    exec jupyter lab --no-browser --port "$PORT"
  else
    exec jupyter lab --port "$PORT"
  fi
fi
