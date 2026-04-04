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

# Layout: single pane, full screen editor
# Split when needed: Prefix+| (horizontal) or Prefix+- (vertical)

tmux send-keys -t "$SESSION" "nvim ." Enter
