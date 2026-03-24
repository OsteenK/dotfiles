#!/usr/bin/env bash
# Arena — Per-agent status watcher (parameterized)
# Usage: agent-watcher.sh <agent_name> <icon>
#   e.g.: agent-watcher.sh logic "🔍"
#         agent-watcher.sh ui "🎨"
#         agent-watcher.sh linter "🧹"

AGENT_NAME="${1:-unknown}"
AGENT_ICON="${2:-●}"
AGENT_UPPER=$(echo "$AGENT_NAME" | tr '[:lower:]' '[:upper:]')

ARENA_DIR="$HOME/.claude/arena"
THEME_FILE="${ARENA_DIR}/current_theme"
LOG_FILE="${ARENA_DIR}/agents/${AGENT_NAME}.log"

# Ensure log file exists
touch "$LOG_FILE"

reload_theme() {
    local theme
    theme=$(cat "$THEME_FILE" 2>/dev/null || echo "matrix")
    source "${ARENA_DIR}/themes/${theme}.sh"
}

get_status() {
    local last_line last_ts now_ts diff
    last_line=$(tail -1 "$LOG_FILE" 2>/dev/null)

    if [[ -z "$last_line" ]]; then
        echo "STANDBY"
        return
    fi

    # Extract timestamp [HH:MM:SS] from log line
    last_ts=$(echo "$last_line" | grep -oP '\d{2}:\d{2}:\d{2}' | head -1)
    if [[ -z "$last_ts" ]]; then
        echo "STANDBY"
        return
    fi

    now_ts=$(date +%s)
    log_ts=$(date -d "today $last_ts" +%s 2>/dev/null || echo 0)
    diff=$(( now_ts - log_ts ))

    if (( diff < 60 )); then
        echo "ACTIVE"
    elif (( diff < 300 )); then
        echo "IDLE"
    else
        echo "STANDBY"
    fi
}

format_status() {
    local status=$1
    case "$status" in
        ACTIVE)  echo -e "${C_ACTIVE}● ACTIVE${C_RESET}" ;;
        IDLE)    echo -e "${C_IDLE}◐ IDLE${C_RESET}" ;;
        STANDBY) echo -e "${C_STANDBY}○ STANDBY${C_RESET}" ;;
    esac
}

colorize_prefix() {
    local line=$1
    # Color log prefixes
    line=$(echo "$line" | sed \
        -e "s/\[START\]/$(printf "${C_OK}")[START]$(printf "${C_RESET}")/g" \
        -e "s/\[CHECK\]/$(printf "${C_LABEL}")[CHECK]$(printf "${C_RESET}")/g" \
        -e "s/\[SCAN\]/$(printf "${C_ACCENT}")[SCAN]$(printf "${C_RESET}")/g" \
        -e "s/\[FIX\]/$(printf "${C_WARN}")[FIX]$(printf "${C_RESET}")/g" \
        -e "s/\[DONE\]/$(printf "${C_OK}")[DONE]$(printf "${C_RESET}")/g" \
        -e "s/\[ERROR\]/$(printf "${C_ERROR}")[ERROR]$(printf "${C_RESET}")/g")
    echo -e "$line"
}

while true; do
    reload_theme
    clear

    status=$(get_status)

    echo -e "${C_HEADER}  ╔══════════════════════════════╗${C_RESET}"
    echo -e "${C_HEADER}  ║  ${AGENT_ICON}  ${AGENT_UPPER}$(printf '%*s' $((24 - ${#AGENT_UPPER})) '')║${C_RESET}"
    echo -e "${C_HEADER}  ╚══════════════════════════════╝${C_RESET}"
    echo ""
    echo -e "  Status: $(format_status $status)"
    echo ""
    echo -e "  ${C_SEPARATOR}──────────────────────────────${C_RESET}"
    echo ""

    # Show last 15 log lines
    line_count=$(wc -l < "$LOG_FILE" 2>/dev/null || echo 0)
    if (( line_count > 0 )); then
        tail -15 "$LOG_FILE" | while IFS= read -r line; do
            colorize_prefix "  $line"
        done
    else
        echo -e "  ${C_DIM}Waiting for activity...${C_RESET}"
        echo ""
        echo -e "  ${C_DIM}Log to this pane with:${C_RESET}"
        echo -e "  ${C_VALUE}arena-log ${AGENT_NAME} \"message\"${C_RESET}"
    fi

    echo ""
    echo -e "  ${C_DIM}Updated: $(date '+%H:%M:%S')${C_RESET}"

    # Use inotifywait if available, otherwise poll
    if command -v inotifywait &>/dev/null; then
        inotifywait -qq -t 5 -e modify "$LOG_FILE" 2>/dev/null
    else
        sleep 3
    fi
done
