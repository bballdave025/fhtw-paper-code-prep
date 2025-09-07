#!/usr/bin/env bash
# Fix common first-line glitches in *.sh and *.py:
#  - Remove a standalone backslash "\" on line 1
#  - Remove a UTF-8 BOM on line 1
# Optional: --add-shebang will add a shebang to files that lack one,
#           choosing based on extension (.sh -> bash, .py -> python3).
#
# It first creates a repo backup tarball (no spaces in name), then
# prints a per-file report of changes.
#
# Usage:
#   fix_firstline_glitches.sh [--root <dir>] [--dry-run] [--add-shebang]
#                              [--ext ".sh,.py"] [--no-backup]
#
# Defaults:
#   --root: git root if available, else CWD
#   --ext:  ".sh,.py"
#   backup: ON (writes to <root>/backups)
#
#
# More-complete Usage examples
#
# # Normal run at repo root,default extensions (.sh,.py),with backup and report
# bin/fix_firstline_glitches.sh
#
# # Dry-run (no changes), just show what *would* be done
# bin/fix_firstline_glitches.sh --dry-run
#
# # Opt-in: also add shebangs to files that lack one (based on extension)
# bin/fix_firstline_glitches.sh --add-shebang
# 
# # Run on a subdirectory only (e.g., your tag dir)
# bin/fix_firstline_glitches.sh --root "$ROOT/test_project_bash/p_01"
#
# # Different extensions (add .ps1 if desired)
# bin/fix_firstline_glitches.sh --ext ".sh,.py,.ps1"
#


set -euo pipefail

# --- args ---
ROOT=""
DRY_RUN=0
ADD_SHEBANG=0
DO_BACKUP=1
EXT_LIST=".sh,.py"

while (( $# )); do
  case "$1" in
    --root) ROOT="${2:?}"; shift 2;;
    --dry-run) DRY_RUN=1; shift;;
    --add-shebang) ADD_SHEBANG=1; shift;;
    --ext) EXT_LIST="${2:?}"; shift 2;;
    --no-backup) DO_BACKUP=0; shift;;
    -h|--help)
      cat <<EOH
Usage: $(basename "$0") [--root <dir>] [--dry-run] [--add-shebang] [--ext ".sh,.py"] [--no-backup]
EOH
      exit 0;;
    *)
      echo "Unknown option: $1" >&2; exit 2;;
  esac
done

# --- resolve root ---
if [[ -z "$ROOT" ]]; then
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    ROOT=$(git rev-parse --show-toplevel)
  else
    ROOT=$(pwd -P)
  fi
fi
cd "$ROOT"

# --- sed in-place portability ---
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(sed -i)
else
  SED_INPLACE=(sed -i '')
fi

timestamp() { date +'%s_%Y-%m-%dT%H%M%S%z'; }

# --- backup ---
BACKUP_PATH=""
if (( DO_BACKUP )); then
  TS="$(timestamp)"
  mkdir -p "$ROOT/backups"
  BACKUP_BASENAME="fix_firstline_glitches_${TS}.tar.gz"
  BACKUP_PATH="$ROOT/backups/$BACKUP_BASENAME"
  echo "Backing up to $BACKUP_PATH"
  # Exclude the backups dir (and this file), and suppress 'file changed as we read it' exits
  tar --create --gzip --file "$BACKUP_PATH" \
      --exclude='./backups/*' \
      --exclude="./backups/$BACKUP_BASENAME" \
      --exclude='*/outputs/*' \
      --exclude='*/datasets/*' \
      --exclude='*/models/*' \
      --exclude='*/what_was_inside_notebook_directory_try1/*' \
      --exclude='*/.ipynb_checkpoints/*' \
      --exclude='*/__pycache__/*' \
      --exclude='*/bash_terminal_io_lab_notebooks/*' \
      --exclude='*/.DS_Store' \
      --warning=no-file-changed \
      --ignore-failed-read \
      . || true
  sha256sum "$BACKUP_PATH" | tee "$BACKUP_PATH.sha256" >/dev/null || true
  echo "Done backing up"
  echo
fi

# --- collect target files ---
# Turn ".sh,.py" into a find predicate
IFS=',' read -r -a exts <<< "$EXT_LIST"
pred=()
for e in "${exts[@]}"; do
  e="${e#"."}"           # strip leading dot if present
  pred+=( -iname "*.${e}" -o )
done
# drop trailing -o
unset 'pred[${#pred[@]}-1]'

mapfile -d '' FILES < <(find . -type f \( "${pred[@]}" \) -print0)

# --- helpers ---
strip_firstline_backslash() {
  # remove a line-1 that is exactly "\" (standalone backslash)
  "${SED_INPLACE[@]}" '1{/^\\$/d;}' "$1"
}

strip_bom() {
  # remove UTF-8 BOM at start of file
  if sed --version >/dev/null 2>&1; then
    "${SED_INPLACE[@]}" '1s/^\xEF\xBB\xBF//g' "$1"
  else
    "${SED_INPLACE[@]}" $'1s/^\xEF\xBB\xBF//' "$1"
  fi
}

file_is_text() {
  LC_ALL=C grep -Iq . -- "$1"
}

first2_bytes_hex() {
  head -c 2 -- "$1" | xxd -p -l 2 2>/dev/null || true
}

has_shebang() {
  [[ "$(head -c 2 -- "$1" 2>/dev/null || true)" == '#!' ]]
}

add_shebang_if_requested() {
  local f="$1"
  (( ADD_SHEBANG )) || return 0
  has_shebang "$f" && return 0

  # choose interpreter by extension
  case "${f##*.}" in
    sh)  line='#!/usr/bin/env bash';;
    py)  line='#!/usr/bin/env python3';;
    *)   return 0;;
  esac

  # Prepend shebang safely (preserving existing content)
  if (( DRY_RUN )); then
    return 0
  fi
  # If file starts with BOM, remove it first so shebang is byte 0
  strip_bom "$f"
  tmp="$(mktemp)"
  printf '%s\n' "$line" > "$tmp"
  cat -- "$f" >> "$tmp"
  mv -- "$tmp" "$f"
  chmod +x "$f" || true
  return 0
}

# --- processing ---
echo "Checking and changing files"
CHANGES=0
for f in "${FILES[@]}"; do
  # skip binaries just in case
  file_is_text "$f" || { echo "$f : skipped (binary)"; continue; }

  pre_hex="$(first2_bytes_hex "$f")"
  pre_hassb=0; has_shebang "$f" && pre_hassb=1

  action_msgs=()
  changed=0

  # simulate or apply
  if (( DRY_RUN )); then
    # dry-run: check whether we'd change anything
    # Check BOM:
    if [[ "$pre_hex" =~ ^ef ]]; then
      action_msgs+=( "UTF-8 BOM stripped (would)" )
    fi
    # Check standalone backslash on L1
    if head -n1 -- "$f" | grep -qE '^[\\]$'; then
      action_msgs+=( "first-line backslash stripped (would)" )
    fi
    # Shebang add?
    if (( ! pre_hassb )); then
      if (( ADD_SHEBANG )); then
        case "${f##*.}" in
          sh|py) action_msgs+=( "shebang added (would)" );;
        esac
      else
        action_msgs+=( "doesn't start with shebang" )
      fi
    fi
  else
    # live edits
    # strip BOM if present
    if [[ "$pre_hex" =~ ^ef ]]; then
      strip_bom "$f"; action_msgs+=( "UTF-8 BOM stripped" ); changed=1
    fi
    # strip standalone backslash on line 1
    if head -n1 -- "$f" | grep -qE '^[\\]$'; then
      strip_firstline_backslash "$f"; action_msgs+=( "first-line backslash stripped" ); changed=1
    fi
    # optionally add shebang
    if (( ! pre_hassb )); then
      if add_shebang_if_requested "$f"; then
        if (( ADD_SHEBANG )); then
          action_msgs+=( "shebang added" ); changed=1
        else
          action_msgs+=( "doesn't start with shebang" )
        fi
      fi
    fi
  fi

  if (( changed )); then
    (( CHANGES++ ))
    echo "$f : ${action_msgs[*]}"
  else
    # print consistent status line
    if ((${#action_msgs[@]})); then
      echo "$f : ${action_msgs[*]}"
    else
      echo "$f : no change"
    fi
  fi
done

echo
if (( DRY_RUN )); then
  echo "Dry-run complete. Files that say '(would)' would be modified."
else
  echo "Edits complete. $CHANGES file(s) modified."
fi

# Exit nonzero in dry-run if we WOULD change anything (useful in CI)
if (( DRY_RUN && CHANGES > 0 )); then
  exit 3
fi

exit 0
