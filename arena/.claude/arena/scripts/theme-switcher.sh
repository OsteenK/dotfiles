#!/usr/bin/env bash
# Arena — Hot-swap theme at runtime
# Usage: theme-switcher.sh <theme_name|cycle>

ARENA_DIR="$HOME/.claude/arena"
THEME_FILE="${ARENA_DIR}/current_theme"
THEMES=("matrix" "damu" "cyberpunk" "mixed")

current_theme=$(cat "$THEME_FILE" 2>/dev/null || echo "matrix")
action="${1:-cycle}"

if [[ "$action" == "cycle" ]]; then
    # Find current index and advance
    idx=0
    for i in "${!THEMES[@]}"; do
        if [[ "${THEMES[$i]}" == "$current_theme" ]]; then
            idx=$i
            break
        fi
    done
    next_idx=$(( (idx + 1) % ${#THEMES[@]} ))
    new_theme="${THEMES[$next_idx]}"
else
    new_theme="$action"
    # Validate theme exists
    if [[ ! -f "${ARENA_DIR}/themes/${new_theme}.sh" ]]; then
        tmux display-message "Theme '${new_theme}' not found. Available: ${THEMES[*]}"
        exit 1
    fi
fi

# Write new theme
echo "$new_theme" > "$THEME_FILE"

# Source theme for tmux colors
source "${ARENA_DIR}/themes/${new_theme}.sh"

# Apply tmux colors immediately
tmux set -g status-style "bg=${TMUX_STATUS_BG},fg=${TMUX_STATUS_FG}"
tmux set -g status-left-style "bg=${TMUX_STATUS_LEFT_BG},fg=${TMUX_STATUS_LEFT_FG}"
tmux set -g window-status-style "bg=${TMUX_WINDOW_BG},fg=${TMUX_WINDOW_FG}"
tmux set -g window-status-current-style "bg=${TMUX_WINDOW_ACTIVE_BG},fg=${TMUX_WINDOW_ACTIVE_FG}"
tmux set -g pane-border-style "fg=${TMUX_PANE_BORDER}"
tmux set -g pane-active-border-style "fg=${TMUX_PANE_ACTIVE_BORDER}"
tmux set -g message-style "bg=${TMUX_MESSAGE_BG},fg=${TMUX_MESSAGE_FG}"

tmux display-message "Theme: ${THEME_NAME}"
