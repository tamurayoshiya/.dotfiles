#!/bin/sh
# TUI project directory picker
# Navigate with j/k or arrow keys, Enter to select, q to quit

_p_projects="$HOME/projects"

if [ ! -d "$_p_projects" ]; then
  printf "Not found: %s\n" "$_p_projects"
  return 1 2>/dev/null || exit 1
fi

_p_dirs=""
for _p_d in "$_p_projects"/*/; do
  [ -d "$_p_d" ] || continue
  _p_name=${_p_d%/}
  _p_name=${_p_name##*/}
  if [ -z "$_p_dirs" ]; then
    _p_dirs="$_p_name"
  else
    _p_dirs="$(printf '%s\n%s' "$_p_dirs" "$_p_name")"
  fi
done

if [ -z "$_p_dirs" ]; then
  printf "No subdirectories in %s\n" "$_p_projects"
  return 1 2>/dev/null || exit 1
fi

_p_total=$(printf '%s\n' "$_p_dirs" | wc -l | tr -d ' ')
_p_sel=0
_p_oldtty=$(stty -g)

_p_cleanup() {
  stty "$_p_oldtty" 2>/dev/null
  tput cnorm 2>/dev/null
  trap - INT TERM
}

_p_nth() {
  printf '%s\n' "$_p_dirs" | sed -n "${1}p"
}

_p_draw() {
  [ "${1:-}" != "first" ] && printf "\033[%dA" "$((_p_total + 2))"
  printf "\033[1m\033[34m  ~/projects\033[0m\n"
  printf "\033[2m  j/k ↑/↓:move  Enter:select  q:quit\033[0m\n"
  _p_i=0
  while [ "$_p_i" -lt "$_p_total" ]; do
    _p_item=$(_p_nth "$((_p_i + 1))")
    if [ "$_p_i" -eq "$_p_sel" ]; then
      printf "\033[1m\033[36m  > %s\033[0m\n" "$_p_item"
    else
      printf "    %s\n" "$_p_item"
    fi
    _p_i=$((_p_i + 1))
  done
}

trap '_p_cleanup' INT TERM
tput civis 2>/dev/null
_p_draw first
stty -icanon -echo

while :; do
  _p_key=$(dd bs=1 count=1 2>/dev/null)
  case "$_p_key" in
    k)
      [ "$_p_sel" -gt 0 ] && _p_sel=$((_p_sel - 1))
      ;;
    j)
      [ "$_p_sel" -lt "$((_p_total - 1))" ] && _p_sel=$((_p_sel + 1))
      ;;
    "$(printf '\033')")
      stty -icanon -echo min 0 time 1
      _p_esc=$(dd bs=2 count=1 2>/dev/null)
      stty -icanon -echo min 1 time 0
      case "$_p_esc" in
        "[A") [ "$_p_sel" -gt 0 ] && _p_sel=$((_p_sel - 1)) ;;
        "[B") [ "$_p_sel" -lt "$((_p_total - 1))" ] && _p_sel=$((_p_sel + 1)) ;;
        "") _p_cleanup; return 0 2>/dev/null || exit 0 ;;
      esac
      ;;
    "")
      _p_cleanup
      _p_target="$_p_projects/$(_p_nth "$((_p_sel + 1))")"
      printf "\n"
      cd "$_p_target" || { return 1 2>/dev/null || exit 1; }
      return 0 2>/dev/null || exit 0
      ;;
    q)
      _p_cleanup
      return 0 2>/dev/null || exit 0
      ;;
  esac
  _p_draw
done
