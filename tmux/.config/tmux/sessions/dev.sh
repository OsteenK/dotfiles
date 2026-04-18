#!/usr/bin/env bash
# dev.sh — Dev layout: nvim (70%) top, terminal (30%) bottom
# Usage: dev.sh <session-name> <directory>
set -euo pipefail

SESSION="${1:?Usage: dev.sh <session-name> <directory>}"
DIR="${2:?Usage: dev.sh <session-name> <directory>}"

# Expand ~ if present
DIR="${DIR/#\~/$HOME}"

if [[ ! -d "$DIR" ]]; then
    echo "Directory not found: $DIR"
    exit 1
fi

# Window name: git branch if available, else directory basename
WIN_NAME=$(git -C "$DIR" branch --show-current 2>/dev/null) || true
WIN_NAME="${WIN_NAME:-$(basename "$DIR")}"

# Create session with named window
tmux new-session -d -s "$SESSION" -c "$DIR" -n "$WIN_NAME"

# Split: bottom terminal pane (30%)
tmux split-window -t "$SESSION" -v -l 30% -c "$DIR"

# Focus top pane (nvim)
tmux select-pane -t "$SESSION:.1"
tmux send-keys -t "$SESSION:.1" "nvim ." Enter
