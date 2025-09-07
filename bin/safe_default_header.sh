
#!/usr/bin/env bash
# safe_default_header.sh — DEV-ONLY shell header (template)
# This header is meant for local/dev shells and notebooks. DO NOT source in production scripts or Docker images.
# Recommended usage in dev scripts:
#   source "$(git rev-parse --show-toplevel 2>/dev/null || echo .)/bin/safe_default_header.sh"
#
# What this header SHOULD do (you can customize below as needed):
#   - set -Eeuo pipefail
#   - sane IFS
#   - detect PROJECT_ROOT and export TAG/TAGDIR defaults if unset
#   - minimal logging helpers (say, warn, err)

# --- Safe defaults ---
set -Eeuo pipefail
IFS=$' \t\n'

# PROJECT_ROOT resolution (git root or cwd)
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
export PROJECT_ROOT

# TAG/TAGDIR fallbacks (non-invasive)
export TAG="${TAG:-$(basename "$PROJECT_ROOT")}"
export TAGDIR="${TAGDIR:-$PROJECT_ROOT}"

# Minimal log helpers
say()  { printf "\033[1;34m[info]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[err]\033[0m %s\n" "$*"; }  # stderr

# You may add dev-only exports or path tweaks below as needed.
# e.g., export PYTHONWARNINGS=default

