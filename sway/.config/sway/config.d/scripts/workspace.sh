#!/bin/sh
if [ -z "$1" ]; then
  echo "Usage: $0 <workspace-number> [move]"
  exit 1
fi
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/sway/config.d/workspace-outputs.conf"
current_output=$(swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused) | .output')

base=""
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
  "" | "#"*) continue ;; # skip comments/empty
  esac

  pattern="${line%%=*}" # everything before first =
  offset="${line#*=}"   # everything after first =

  case "$current_output" in
  $pattern)
    base="$offset"
    break
    ;;
  esac
done <"$CONFIG"

if [ -z "$base" ]; then
  echo "Unknown output: $current_output" >&2
  echo "Add a line to $CONFIG, e.g. ${current_output%%-*}=30" >&2
  exit 1
fi

workspace_number=$((base + $1))
workspace_cmd="workspace number $workspace_number"
move_workspace_cmd="move workspace to output $current_output"

if [ "$2" = "move" ]; then
  swaymsg move container to workspace number "$workspace_number"
  swaymsg "$workspace_cmd"
  swaymsg "$move_workspace_cmd"
  swaymsg "$workspace_cmd"
else
  swaymsg "$workspace_cmd"
  swaymsg "$move_workspace_cmd"
fi
