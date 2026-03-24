#!/usr/bin/env bash
# claude.sh — Single pane Claude Code session
set -euo pipefail

SESSION="Claude"

tmux new-session -d -s "$SESSION" -c "$HOME"
tmux send-keys -t "$SESSION" "claude" Enter
