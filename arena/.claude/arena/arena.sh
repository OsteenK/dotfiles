#!/usr/bin/env bash
# Arena — Hacker-Style tmux Dashboard for Claude Code
# Usage:
#   arena                    Launch with default (matrix) theme
#   arena --theme <name>     Launch with specific theme (matrix|damu|cyberpunk|mixed)
#   arena --kill             Kill the arena session
#   arena --help             Show help

set -euo pipefail

ARENA_DIR="$HOME/.claude/arena"
SESSION="arena"
THEME_FILE="${ARENA_DIR}/current_theme"
SCRIPTS="${ARENA_DIR}/scripts"
THEMES_DIR="${ARENA_DIR}/themes"

# Parse arguments
THEME="matrix"
ACTION="launch"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --theme|-t)
            THEME="${2:-matrix}"
            shift 2
            ;;
        --kill|-k)
            ACTION="kill"
            shift
            ;;
        --help|-h)
            ACTION="help"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Help
if [[ "$ACTION" == "help" ]]; then
    echo "Arena — Hacker-Style tmux Dashboard for Claude Code"
    echo ""
    echo "Usage:"
    echo "  arena                    Launch with default (matrix) theme"
    echo "  arena --theme <name>     Launch with theme (matrix|damu|cyberpunk|mixed)"
    echo "  arena --kill             Kill the arena session"
    echo ""
    echo "Keybindings (inside arena):"
    echo "  Ctrl+A         Prefix key"
    echo "  Prefix+T       Cycle themes"
    echo "  Prefix+F1-F4   Direct theme select"
    echo "  Alt+Arrows     Navigate panes"
    echo "  Prefix+0       Jump to main pane"
    echo "  Prefix+f       Fullscreen toggle"
    echo "  Prefix+C       Clear all agent logs"
    exit 0
fi

# Kill
if [[ "$ACTION" == "kill" ]]; then
    if tmux has-session -t "$SESSION" 2>/dev/null; then
        tmux kill-session -t "$SESSION"
        echo "Arena session killed."
    else
        echo "No arena session running."
    fi
    exit 0
fi

# Validate theme
if [[ ! -f "${THEMES_DIR}/${THEME}.sh" ]]; then
    echo "Theme '${THEME}' not found. Available: matrix, damu, cyberpunk, mixed"
    exit 1
fi

# If session exists, reattach
if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Reattaching to existing arena session..."
    tmux attach -t "$SESSION"
    exit 0
fi

# Write current theme
echo "$THEME" > "$THEME_FILE"

# Source theme for tmux colors
source "${THEMES_DIR}/${THEME}.sh"

# Ensure log files exist
mkdir -p "${ARENA_DIR}/agents"
touch "${ARENA_DIR}/agents/activity.log"

# Clear dynamic pane tracker from previous session
> "${ARENA_DIR}/agents/.panes"

# Make all scripts executable
chmod +x "${SCRIPTS}"/*.sh

# ─── Create tmux session with layout ───
#
# Layout (4 panes — agents spawn dynamically):
# ┌──────────────────────────┬────────────┐
# │                          │ SYSTEM (3) │
# │     MAIN (1)             ├────────────┤
# │                          │ GIT (4)    │
# ├──────────────────────────┴────────────┤
# │  ACTIVITY LOG (2)                      │
# └────────────────────────────────────────┘

# Create session with first window, start in home dir
tmux new-session -d -s "$SESSION" -x "$(tput cols)" -y "$(tput lines)"

# Load arena tmux config
tmux source-file "${ARENA_DIR}/tmux.conf"

# Apply theme colors
tmux set -t "$SESSION" -g status-style "bg=${TMUX_STATUS_BG},fg=${TMUX_STATUS_FG}"
tmux set -t "$SESSION" -g status-left " ⚡ ARENA [${THEME_NAME}] "
tmux set -t "$SESSION" -g status-left-style "bg=${TMUX_STATUS_LEFT_BG},fg=${TMUX_STATUS_LEFT_FG},bold"
tmux set -t "$SESSION" -g status-right " %H:%M:%S "
tmux set -t "$SESSION" -g window-status-style "bg=${TMUX_WINDOW_BG},fg=${TMUX_WINDOW_FG}"
tmux set -t "$SESSION" -g window-status-current-style "bg=${TMUX_WINDOW_ACTIVE_BG},fg=${TMUX_WINDOW_ACTIVE_FG}"
tmux set -t "$SESSION" -g pane-border-style "fg=${TMUX_PANE_BORDER}"
tmux set -t "$SESSION" -g pane-active-border-style "fg=${TMUX_PANE_ACTIVE_BORDER}"
tmux set -t "$SESSION" -g message-style "bg=${TMUX_MESSAGE_BG},fg=${TMUX_MESSAGE_FG}"

# Pane 1 is the initial pane (main Claude session area)
# Split bottom: activity log (pane 2)
tmux split-window -t "$SESSION" -v -l 20%

# Select top pane (pane 1) and split right: creates right column (pane 3)
tmux select-pane -t "$SESSION".1
tmux split-window -t "$SESSION" -h -l 30%

# Split right column (pane 3) into System (3) and Git (4)
tmux select-pane -t "$SESSION".3
tmux split-window -t "$SESSION" -v -l 50%

# Pane 1: Main Claude session — show banner then drop to shell
tmux send-keys -t "$SESSION".1 "bash ${SCRIPTS}/banner.sh && clear && echo -e '\\033[1;38;5;46m  MAIN SESSION — run claude here\\033[0m' && echo ''" Enter

# Pane 3: System monitor
tmux send-keys -t "$SESSION".3 "bash ${SCRIPTS}/sys-monitor.sh" Enter

# Pane 4: Git watcher
tmux send-keys -t "$SESSION".4 "bash ${SCRIPTS}/git-watcher.sh" Enter

# Pane 2: Activity log
tmux send-keys -t "$SESSION".2 "bash ${SCRIPTS}/activity-watcher.sh" Enter

# Select the main pane
tmux select-pane -t "$SESSION".1

# Log startup
ts=$(date '+%H:%M:%S')
echo "[${ts}] [SYSTEM] [START] Arena launched — theme: ${THEME_NAME}" >> "${ARENA_DIR}/agents/activity.log"

# Attach
tmux attach -t "$SESSION"
