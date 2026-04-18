#!/usr/bin/env bash
# restore-session.sh — Restore tmux sessions from last save
# Reads from ~/.tmux/resurrect/last/*.txt
set -euo pipefail

SAVE_DIR="$HOME/.tmux/resurrect/last"
SESSIONS_DIR="$HOME/.config/tmux/sessions"

if [[ ! -d "$SAVE_DIR" ]]; then
    echo "No saved sessions found at $SAVE_DIR"
    exit 1
fi

# Commands safe to re-launch (others just get their directory)
RELAUNCH_WHITELIST="nvim:htop:claude:watch:journalctl"

# Sessions with dedicated template scripts — run template instead of generic restore
declare -A TEMPLATE_SESSIONS=(
    ["Arena"]="$SESSIONS_DIR/arena.sh"
    ["Monitor"]="$SESSIONS_DIR/monitor.sh"
    ["Claude"]="$SESSIONS_DIR/claude.sh"
)

restored=0
skipped=0

for savefile in "$SAVE_DIR"/*.txt; do
    [[ -f "$savefile" ]] || continue

    session_name=$(basename "$savefile" .txt)

    # Skip already-running sessions
    if tmux has-session -t "$session_name" 2>/dev/null; then
        ((skipped++))
        continue
    fi

    # If this session has a dedicated template, use it
    if [[ -n "${TEMPLATE_SESSIONS[$session_name]:-}" ]]; then
        template="${TEMPLATE_SESSIONS[$session_name]}"
        if [[ -x "$template" || -f "$template" ]]; then
            bash "$template" 2>/dev/null || true
            ((restored++))
            echo "Restored (template): $session_name"
            continue
        fi
    fi

    # Generic restore from save file
    local_created=false
    while IFS=: read -r sess win_idx pane_idx win_name pane_path pane_cmd; do
        [[ -d "$pane_path" ]] || pane_path="$HOME"

        if ! $local_created; then
            # First pane — create the session
            tmux new-session -d -s "$session_name" -c "$pane_path" -x 200 -y 50
            tmux rename-window -t "$session_name:1" "$win_name"
            local_created=true
            current_win=1
        elif [[ "$win_idx" != "$current_win" ]]; then
            # New window
            tmux new-window -t "$session_name" -c "$pane_path" -n "$win_name"
            current_win="$win_idx"
        else
            # New pane in current window
            tmux split-window -t "$session_name" -c "$pane_path"
            tmux select-layout -t "$session_name" tiled >/dev/null 2>&1 || true
        fi

        # Re-launch whitelisted commands
        if [[ ":$RELAUNCH_WHITELIST:" == *":$pane_cmd:"* ]]; then
            case "$pane_cmd" in
                nvim)  tmux send-keys -t "$session_name" "nvim ." Enter ;;
                htop)  tmux send-keys -t "$session_name" "htop" Enter ;;
                claude) tmux send-keys -t "$session_name" "claude" Enter ;;
                *)     tmux send-keys -t "$session_name" "$pane_cmd" Enter ;;
            esac
        fi
    done < "$savefile"

    if $local_created; then
        # Select first window, first pane
        tmux select-window -t "$session_name:1" 2>/dev/null || true
        tmux select-pane -t "$session_name:1.1" 2>/dev/null || true
        ((restored++))
        echo "Restored: $session_name"
    fi
done

echo "Done — restored: $restored, skipped (already running): $skipped"
