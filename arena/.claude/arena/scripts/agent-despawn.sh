#!/usr/bin/env bash
# Arena — Close a dynamic agent pane
# Usage: agent-despawn.sh <agent_name>

set -euo pipefail

AGENT_NAME="${1:?Usage: agent-despawn.sh <agent_name>}"

ARENA_DIR="$HOME/.claude/arena"
SESSION="arena"
PANES_FILE="${ARENA_DIR}/agents/.panes"
LOG_DIR="${ARENA_DIR}/agents"

# Check arena session exists
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    exit 0
fi

# Check if .panes file exists
if [[ ! -f "$PANES_FILE" ]]; then
    exit 0
fi

# Find pane ID for this agent
pane_id=$(grep "^${AGENT_NAME}=" "$PANES_FILE" 2>/dev/null | cut -d= -f2 || true)
if [[ -z "$pane_id" ]]; then
    exit 0
fi

# Kill the pane if it's still alive (tmux auto-reclaims space)
if tmux list-panes -t "$SESSION" -F '#{pane_id}' 2>/dev/null | grep -q "^${pane_id}$"; then
    tmux kill-pane -t "${SESSION}.${pane_id}" 2>/dev/null || true
fi

# Remove entry from tracker
sed -i "/^${AGENT_NAME}=/d" "$PANES_FILE"

# Log to activity
ts=$(date '+%H:%M:%S')
echo "[${ts}] [SYSTEM] Agent pane closed: ${AGENT_NAME}" >> "$LOG_DIR/activity.log"
