#!/usr/bin/env bash
# Safe default Bash header for use in dwb_bash_util repo.
# Source this in new scripts, or paste directly at the top.

# --- Safe defaults ------------------------------------------------------------
set -euo pipefail
IFS=$' \t\n'

# --- Pretty logging -----------------------------------------------------------
info() { printf '[info] %s\n' "$*" >&2; }
warn() { printf '[warn] %s\n' "$*" >&2; }
die()  { printf '[err]  %s\n' "$*" >&2; exit 1; }

# --- Command presence check ---------------------------------------------------
# usage: require_cmd tar jq aws
require_cmd() {
  local missing=()
  for c in "$@"; do command -v "$c" >/dev/null 2>&1 || missing+=("$c"); done
  ((${#missing[@]}==0)) || die "Missing required command(s): ${missing[*]}"
}

# --- ERR trap with file:line and last command ---------------------------------
_last_cmd=""
trap 'rc=$?; [ $rc -eq 0 ] || warn "failed($rc): ${_last_cmd} at ${BASH_SOURCE[0]}:${LINENO}"' ERR
PROMPT_COMMAND=':_last_cmd=$BASH_COMMAND'

# --- Temp dir with automatic clean-up ----------------------------------------
mktempdir() {
  local d; d="$(mktemp -d 2>/dev/null || mktemp -d -t tmp)" || die "mktemp failed"
  # shellcheck disable=SC2064
  trap "rm -rf '$d'" EXIT
  printf '%s\n' "$d"
}

# --- Scoped “allow failure” helpers ------------------------------------------
try()   { "$@"; return 0; }
maybe() { set +e; "$@"; local rc=$?; set -e; return $rc; }

# --- Safe pushd/popd wrappers (quiet) -----------------------------------------
pushd_quiet() { pushd "$1" >/dev/null || die "pushd $1"; }
popd_quiet()  { popd        >/dev/null || die "popd"; }

# --- End header; script body goes below ---------------------------------------
