#!/usr/bin/env bash
# Arena — Unified activity log tail (all agents)

ARENA_DIR="$HOME/.claude/arena"
THEME_FILE="${ARENA_DIR}/current_theme"
ACTIVITY_LOG="${ARENA_DIR}/agents/activity.log"

# Ensure log exists
touch "$ACTIVITY_LOG"

reload_theme() {
    local theme
    theme=$(cat "$THEME_FILE" 2>/dev/null || echo "matrix")
    source "${ARENA_DIR}/themes/${theme}.sh"
}

colorize_agent() {
    local line=$1
    # Color agent names differently
    line=$(echo "$line" | sed \
        -e "s/\[LOGIC\]/$(printf "${C_ACCENT}")[LOGIC]$(printf "${C_RESET}")/g" \
        -e "s/\[UI\]/$(printf "${C_OK}")[UI]$(printf "${C_RESET}")/g" \
        -e "s/\[LINTER\]/$(printf "${C_WARN}")[LINTER]$(printf "${C_RESET}")/g" \
        -e "s/\[MUTINDA\]/$(printf "${C_HEADER}")[MUTINDA]$(printf "${C_RESET}")/g" \
        -e "s/\[INNOVATOR\]/$(printf "${C_VALUE}")[INNOVATOR]$(printf "${C_RESET}")/g" \
        -e "s/\[SYSTEM\]/$(printf "${C_DIM}")[SYSTEM]$(printf "${C_RESET}")/g")

    # Color status prefixes
    line=$(echo "$line" | sed \
        -e "s/\[START\]/$(printf "${C_OK}")[START]$(printf "${C_RESET}")/g" \
        -e "s/\[DONE\]/$(printf "${C_OK}")[DONE]$(printf "${C_RESET}")/g" \
        -e "s/\[ERROR\]/$(printf "${C_ERROR}")[ERROR]$(printf "${C_RESET}")/g" \
        -e "s/\[FIX\]/$(printf "${C_WARN}")[FIX]$(printf "${C_RESET}")/g" \
        -e "s/\[SCAN\]/$(printf "${C_ACCENT}")[SCAN]$(printf "${C_RESET}")/g" \
        -e "s/\[CHECK\]/$(printf "${C_LABEL}")[CHECK]$(printf "${C_RESET}")/g")

    echo -e "$line"
}

# Initial render
reload_theme
clear
echo -e "${C_HEADER}  ╔═══════════════════════════════════════════════════════════════╗${C_RESET}"
echo -e "${C_HEADER}  ║              📋  ACTIVITY LOG  (all agents)                   ║${C_RESET}"
echo -e "${C_HEADER}  ╚═══════════════════════════════════════════════════════════════╝${C_RESET}"
echo ""

# Show existing lines
if [[ -s "$ACTIVITY_LOG" ]]; then
    tail -20 "$ACTIVITY_LOG" | while IFS= read -r line; do
        colorize_agent "  $line"
    done
else
    echo -e "  ${C_DIM}Waiting for agent activity...${C_RESET}"
    echo ""
    echo -e "  ${C_DIM}Log with: arena-log <agent> \"message\"${C_RESET}"
fi

echo ""
echo -e "  ${C_SEPARATOR}─────────────────────────────────────────────${C_RESET}"

# Tail and colorize new entries
tail -f -n 0 "$ACTIVITY_LOG" 2>/dev/null | while IFS= read -r line; do
    # Periodically reload theme (every line is fine since it's event-driven)
    reload_theme
    colorize_agent "  $line"
done
