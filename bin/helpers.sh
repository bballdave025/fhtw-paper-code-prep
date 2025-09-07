
# --- helpers: elapsed timer & format (idempotent) ---
# elapsed: start/stop/check a stopwatch stored at /tmp/.elapsed_timer
# Prints: "<total_seconds> (<D>d )HH:MM:SS"
elapsed() {
  local f=/tmp/.elapsed_timer
  _fmt_dhms() {
    # arg: total seconds -> prints "(<D>d )HH:MM:SS"
    local t=$1
    local d=$(( t/86400 ))
    local h=$(( (t%86400)/3600 ))
    local m=$(( (t%3600)/60 ))
    local s=$(( t%60 ))
    if (( d > 0 )); then
      printf "%dd %02d:%02d:%02d" "$d" "$h" "$m" "$s"
    else
      printf "%02d:%02d:%02d" "$h" "$m" "$s"
    fi
  }
  case "${1:-}" in
    -s|--start)
      [ -e "$f" ] && { echo "already started"; return 1; }
      date +%s >"$f"; echo "started"
      ;;
    -p|--stop)
      [ ! -e "$f" ] && { echo "not started"; return 1; }
      local s=$(cat "$f"); rm -f "$f"
      local now=$(date +%s)
      local t=$(( now - s ))
      printf "%d (%s)\n" "$t" "$(_fmt_dhms "$t")"
      ;;
    -c|--check|--status)
      [ ! -e "$f" ] && { echo "not started"; return 1; }
      local s=$(cat "$f")
      local now=$(date +%s)
      local t=$(( now - s ))
      printf "%d (%s)\n" "$t" "$(_fmt_dhms "$t")"
      ;;
    -h|--help|*)
      cat <<'H'
Usage: elapsed [--start|-s] | [--stop|-p] | [--check|-c] | [--help|-h]
  --start  start timer (guards against double-start)
  --stop   print total seconds and (D)d HH:MM:SS, then clear
  --check  print total seconds and (D)d HH:MM:SS (continues running)
H
      ;;
  esac
}
# --- end helpers: elapsed ---
