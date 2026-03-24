#!/usr/bin/env bash
# Arena — Dynamically spawn an agent watcher pane
# Usage: agent-spawn.sh <agent_name> [icon]
#   e.g.: agent-spawn.sh logic "🔍"
#         agent-spawn.sh ui "🎨"

set -euo pipefail

AGENT_NAME="${1:?Usage: agent-spawn.sh <agent_name> [icon]}"
AGENT_ICON="${2:-●}"

ARENA_DIR="$HOME/.claude/arena"
SESSION="arena"
SCRIPTS="${ARENA_DIR}/scripts"
PANES_FILE="${ARENA_DIR}/agents/.panes"
LOG_DIR="${ARENA_DIR}/agents"

# Ensure files/dirs exist
mkdir -p "$LOG_DIR"
touch "$PANES_FILE" "$LOG_DIR/${AGENT_NAME}.log"

# Check if arena session exists
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Arena session not running. Launch with: arena"
    exit 1
fi

# Idempotent — skip if agent pane already exists and is alive
existing_pane=$(grep "^${AGENT_NAME}=" "$PANES_FILE" 2>/dev/null | cut -d= -f2 || true)
if [[ -n "$existing_pane" ]]; then
    # Verify the pane is still alive
    if tmux list-panes -t "$SESSION" -F '#{pane_id}' 2>/dev/null | grep -q "^${existing_pane}$"; then
        exit 0
    else
        # Pane died — remove stale entry
        sed -i "/^${AGENT_NAME}=/d" "$PANES_FILE"
    fi
fi

# Count currently active agent panes (non-empty lines)
active_count=$(grep -c '.' "$PANES_FILE" 2>/dev/null) || active_count=0

# Get the main pane ID (pane index 1, always the top-left main session)
main_pane_id=$(tmux list-panes -t "$SESSION" -F '#{pane_id} #{pane_index}' | awk '$2 == 0 {print $1}')

if (( active_count == 0 )); then
    # First agent — split main pane horizontally to create a middle column
    # The new pane appears to the right of main
    new_pane_id=$(tmux split-window -t "${SESSION}.${main_pane_id}" -h -l 30% -P -F '#{pane_id}')
else
    # Additional agent — find an existing agent pane and split it vertically
    # Get the first agent pane ID from the tracker
    first_agent_pane=$(head -1 "$PANES_FILE" | cut -d= -f2)

    # Verify it's alive, find a living one if not
    if ! tmux list-panes -t "$SESSION" -F '#{pane_id}' 2>/dev/null | grep -q "^${first_agent_pane}$"; then
        # Find any living agent pane
        first_agent_pane=""
        while IFS='=' read -r name pid; do
            if tmux list-panes -t "$SESSION" -F '#{pane_id}' 2>/dev/null | grep -q "^${pid}$"; then
                first_agent_pane="$pid"
                break
            fi
        done < "$PANES_FILE"
    fi

    if [[ -z "$first_agent_pane" ]]; then
        # All tracked panes are dead — start fresh, split from main
        > "$PANES_FILE"
        new_pane_id=$(tmux split-window -t "${SESSION}.${main_pane_id}" -h -l 30% -P -F '#{pane_id}')
    else
        # Split existing agent pane vertically to stack
        new_pane_id=$(tmux split-window -t "${SESSION}.${first_agent_pane}" -v -P -F '#{pane_id}')
    fi
fi

# Record the pane
echo "${AGENT_NAME}=${new_pane_id}" >> "$PANES_FILE"

# Launch agent-watcher inside the new pane
tmux send-keys -t "${SESSION}.${new_pane_id}" "bash ${SCRIPTS}/agent-watcher.sh ${AGENT_NAME} '${AGENT_ICON}'" Enter

# Return focus to main pane
tmux select-pane -t "${SESSION}.${main_pane_id}"

# Log to activity
ts=$(date '+%H:%M:%S')
echo "[${ts}] [SYSTEM] Agent pane spawned: ${AGENT_NAME}" >> "$LOG_DIR/activity.log"
