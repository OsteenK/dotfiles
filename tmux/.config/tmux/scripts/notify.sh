#!/usr/bin/env bash
# notify.sh — Desktop notification for tmux silence alerts
# Called by: set-hook -g alert-silence
# Args: session_name window_index pane_index
set -euo pipefail

SESSION="${1:-unknown}"
WIN_IDX="${2:-0}"
PANE_IDX="${3:-0}"

# Skip if the pane is currently focused (no noise for active work)
active_session=$(tmux display-message -p '#{session_name}' 2>/dev/null) || exit 0
active_window=$(tmux display-message -p '#{window_index}' 2>/dev/null) || exit 0
active_pane=$(tmux display-message -p '#{pane_index}' 2>/dev/null) || exit 0

if [[ "$SESSION" == "$active_session" && "$WIN_IDX" == "$active_window" && "$PANE_IDX" == "$active_pane" ]]; then
    exit 0
fi

# Get the command that just went silent
pane_cmd=$(tmux display-message -t "${SESSION}:${WIN_IDX}.${PANE_IDX}" -p '#{pane_current_command}' 2>/dev/null) || pane_cmd="unknown"

# Skip notifications for interactive TUIs that might go "silent" normally
case "$pane_cmd" in
    nvim|vim|vi|nano|less|man|htop|top|btop|watch|claude|fzf)
        exit 0
        ;;
esac

# Get pane exit status (last command)
pane_dead=$(tmux display-message -t "${SESSION}:${WIN_IDX}.${PANE_IDX}" -p '#{pane_dead}' 2>/dev/null) || pane_dead="0"

# Send notification
if command -v notify-send &>/dev/null; then
    if [[ "$pane_dead" == "1" ]]; then
        notify-send -u critical "tmux [$SESSION]" "Command finished (pane exited) in window $WIN_IDX"
    else
        notify-send -u normal "tmux [$SESSION]" "\"$pane_cmd\" went silent in window $WIN_IDX"
    fi
fi
