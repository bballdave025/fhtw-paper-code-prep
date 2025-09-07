elapsed() {
  local state_file="/tmp/.elapsed_timer"

  case "$1" in
    -s|--start)
      date +%s > "$state_file"
      echo "Stopwatch started."
      ;;
    -p|--stop)
      if [[ -f "$state_file" ]]; then
        local start=$(<"$state_file")
        local now=$(date +%s)
        local diff=$((now - start))
        echo "$diff"
        rm -f "$state_file"
      else
        echo "No stopwatch running. Use --start to begin."
      fi
      ;;
    -c|--check)
      if [[ -f "$state_file" ]]; then
        local start=$(<"$state_file")
        local now=$(date +%s)
        local diff=$((now - start))
        echo "$diff"
      else
        echo "No stopwatch running. Use --start to begin."
      fi
      ;;
    -h|--help|*)
      cat <<EOF
Usage: elapsed [OPTION]

Options:
  -s, --start   Start the stopwatch
  -c, --check   Show elapsed time (in seconds, stopwatch keeps running)
  -p, --stop    Stop the stopwatch and show elapsed time (in seconds)
  -h, --help    Show this help message

If run without an option, this help will be displayed.
EOF
      ;;
  esac
}
