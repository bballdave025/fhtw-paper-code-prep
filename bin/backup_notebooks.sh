\
#!/usr/bin/env bash
# backup_notebooks.sh
# Make timestamped .bak copies of notebooks in ./notebooks/ (or a chosen dir).
# Optionally prune older backups, keeping only the most recent N per notebook.
#
# Timestamp pattern: $(date +'%s_%Y-%m-%dT%H%M%S%z')

set -Eeuo pipefail

#PROJECT_DIR="${PROJECT_DIR:-$PWD}"
PROJECT_DIR=${PROJECT_DIR:-$HOME/my_repos_dwb/fhtw-paper-code-prep/test_project_bash/p_01}
NB_DIR_DEFAULT="notebooks"
NB_DIR=""
PRUNE=0
KEEP="${KEEP:-3}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") [options] [NOTEBOOK.ipynb ...]

Without arguments, operates on all *.ipynb under ./notebooks/.

Options:
  -p, --project DIR     Project directory (default: \$PWD)
  -n, --nbdir DIR       Notebooks subdirectory relative to project (default: notebooks)
  --prune               After backup, prune old backups, keeping last N (see --keep)
  -k, --keep N          Number of backups to keep per notebook when pruning (default: 3)
  -h, --help            Show this help and exit

Env overrides:
  PROJECT_DIR, KEEP

Examples:
  $(basename "$0")
  $(basename "$0") --prune --keep 5
  $(basename "$0") -p "$HOME/my_repos_dwb/fhtw-paper-code-prep/test_project_bash/p_01" --prune
  $(basename "$0") notebooks/01_model_build_p_01.ipynb
USAGE
}

# Parse flags
args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--project) PROJECT_DIR="$2"; shift 2;;
    -n|--nbdir) NB_DIR="$2"; shift 2;;
    --prune) PRUNE=1; shift;;
    -k|--keep) KEEP="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    --) shift; break;;
    -*)
      echo "Unknown option: $1" >&2
      usage; exit 2
      ;;
    *)
      args+=("$1"); shift;;
  esac
done
set -- "${args[@]}"

# Resolve notebook directory
if [[ -z "${NB_DIR}" ]]; then
  NB_DIR="${PROJECT_DIR}/${NB_DIR_DEFAULT}"
elif [[ "${NB_DIR}" != /* ]]; then
  NB_DIR="${PROJECT_DIR}/${NB_DIR}"
fi

if [[ ! -d "$NB_DIR" ]]; then
  echo "No notebooks directory found at: $NB_DIR" >&2
  exit 1
fi

stamp="$(date +'%s_%Y-%m-%dT%H%M%S%z')"

backup_one() {
  local nb="$1"
  if [[ ! -f "$nb" ]]; then
    echo "Skipping non-existent: $nb" >&2
    return 0
  fi
  local bak="${nb}.${stamp}.bak"
  cp -v -- "$nb" "$bak"
  if [[ $PRUNE -eq 1 ]]; then
    prune_backups "$nb"
  fi
}

prune_backups() {
  local nb="$1"
  # List backups for this notebook, sorted by mtime descending, keep first $KEEP, remove rest
  # Note: relies on filenames without newlines; standard in practice.
  local dir base
  dir="$(dirname "$nb")"
  base="$(basename "$nb")"
  # Gather list
  mapfile -t all_baks < <(ls -1t -- "$dir/${base}."*".bak" 2>/dev/null || true)
  if (( ${#all_baks[@]} > KEEP )); then
    # Determine deletions
    local to_delete=( "${all_baks[@]:KEEP}" )
    for old in "${to_delete[@]}"; do
      echo "Pruning old backup: $old"
      rm -f -- "$old"
    done
  fi
}

# Collect notebooks to operate on
nb_list=()
if [[ $# -gt 0 ]]; then
  # Use provided paths
  for p in "$@"; do
    if [[ -d "$p" ]]; then
      while IFS= read -r -d '' f; do nb_list+=("$f"); done < <(find "$p" -maxdepth 1 -type f -name "*.ipynb" -print0)
    else
      nb_list+=("$p")
    fi
  done
else
  while IFS= read -r -d '' f; do nb_list+=("$f"); done < <(find "$NB_DIR" -maxdepth 1 -type f -name "*.ipynb" -print0)
fi

if [[ ${#nb_list[@]} -eq 0 ]]; then
  echo "No notebooks found to back up." >&2
  exit 0
fi

for nb in "${nb_list[@]}"; do
  backup_one "$nb"
done
