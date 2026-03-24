#!/usr/bin/env bash
# dev.sh — 3-pane dev layout (parameterized)
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

# Create session
tmux new-session -d -s "$SESSION" -c "$DIR"

# Layout:
# ┌──────────────────────────┬────────────┐
# │     MAIN (70%)           │ TERMINAL   │
# │                          │ (30%)      │
# ├──────────────────────────┴────────────┤
# │  GIT / COMMANDS (20% height)          │
# └───────────────────────────────────────┘

# Split bottom: git/commands pane
tmux split-window -t "$SESSION" -v -l 20% -c "$DIR"

# Select top pane and split right: terminal pane
tmux select-pane -t "$SESSION".1
tmux split-window -t "$SESSION" -h -l 30% -c "$DIR"

# Pane 1: Main editor area
tmux send-keys -t "$SESSION".1 "nvim ." Enter

# Pane 3: Terminal
tmux send-keys -t "$SESSION".3 "echo '── Terminal ──'" Enter

# Pane 2: Git status
tmux send-keys -t "$SESSION".2 "git status 2>/dev/null || echo 'Not a git repo'" Enter

# Select main pane
tmux select-pane -t "$SESSION".1
