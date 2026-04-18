#!/usr/bin/env bash
# save-session.sh — Save all tmux sessions for later restore
# Format per line: session:win_idx:pane_idx:win_name:pane_path:pane_cmd
set -euo pipefail

SAVE_DIR="$HOME/.tmux/resurrect"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SAVE_PATH="$SAVE_DIR/$TIMESTAMP"

mkdir -p "$SAVE_PATH"

sessions=$(tmux list-sessions -F '#S' 2>/dev/null) || exit 0

for session in $sessions; do
    outfile="$SAVE_PATH/${session}.txt"
    tmux list-panes -t "$session" -s -F \
        '#{session_name}:#{window_index}:#{pane_index}:#{window_name}:#{pane_current_path}:#{pane_current_command}' \
        > "$outfile"
done

# Symlink 'last' to latest save
ln -sfn "$SAVE_PATH" "$SAVE_DIR/last"
