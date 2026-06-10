#!/usr/bin/env bash
set -euo pipefail

SESSION="tidylog"

# Do nothing if the session already exists
if tmux has-session -t "$SESSION" 2>/dev/null; then
tmux attach-session -t "$SESSION"
exit 0
fi

# Create detached session
tmux new-session -d -s "$SESSION" -n nvim

# Window 1: nvim
tmux send-keys -t "$SESSION:nvim" "cd ~/Documents/Dev/tidylog && nvim" C-m

# Window 2: server
tmux new-window -t "$SESSION" -n codex
tmux send-keys -t "$SESSION:codex" "cd ~/Documents/Dev/tidylog && codex" C-m

# Window 3: repo
tmux new-window -t "$SESSION" -n misc
tmux send-keys -t "$SESSION:misc" "cd ~/Documents/Dev/tidylog/tidy/bin/Debug/net10.0 && clear && ls | grep tidy" C-m

tmux split-window -h -t "$SESSION:misc"
tmux send-keys -t "$SESSION:misc.2" "cd ~/Documents/Dev/tidylog && clear && ls && git status" C-m

tmux split-window -v -t "$SESSION:misc.2"
tmux send-keys -t "$SESSION:misc.3" "cd ~/.config/tidylog && nvim tidy.toml" C-m

tmux select-window -t "$SESSION:nvim"
tmux attach-session -t "$SESSION"

