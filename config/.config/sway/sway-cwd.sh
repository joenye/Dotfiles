#!/usr/bin/env bash
# Source: https://www.reddit.com/r/swaywm/comments/fp58p1/get_the_current_working_directory_of_a_window_in/

# Spawn a terminal in the current working directory of the active window
pids="$( swaymsg -t get_tree |
  jq '.. | (.nodes? // empty)[] | select(.focused==true).pid? // empty' |
  xargs pstree -p | grep "\<tmux\>\|\<fish\>\|\<bash\>\|\<zsh\>\|\<sh\>" |
  grep -o '[0-9]*' | sort -h )"
tmuxpath="$( tmux list-clients -F "#{client_pid} #{pane_current_path}" |
  sort -h -k 1 | join - <(echo "$pids") )"
paths="$( echo "$pids" | xargs pwdx 2> /dev/null )"
cwd="$( echo -e "${paths}\n${tmuxpath}" | cut -f2- -d' ' |
  sort | tail -n 1 | tr -d '\n' )"

if [ -d "$cwd" ]; then
  # alacritty --working-directory "$cwd" &
  termite -d "$cwd" &
  disown
else
  termite &
  disown
fi
