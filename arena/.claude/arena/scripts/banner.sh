#!/usr/bin/env bash
# Arena startup banner — displays ASCII art title
# Uses toilet/figlet if available, falls back to static art

ARENA_DIR="$HOME/.claude/arena"
THEME_FILE="${ARENA_DIR}/current_theme"
THEME=$(cat "$THEME_FILE" 2>/dev/null || echo "matrix")
source "${ARENA_DIR}/themes/${THEME}.sh"

clear

# Try toilet first, then figlet, then static
if command -v toilet &>/dev/null; then
    echo -e "${C_BANNER}"
    toilet -f future --filter border "ARENA"
    echo -e "${C_RESET}"
elif command -v figlet &>/dev/null; then
    echo -e "${C_BANNER}"
    figlet -f slant "ARENA"
    echo -e "${C_RESET}"
else
    echo -e "${C_BANNER}"
    cat << 'ART'
     █████╗ ██████╗ ███████╗███╗   ██╗ █████╗
    ██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔══██╗
    ███████║██████╔╝█████╗  ██╔██╗ ██║███████║
    ██╔══██║██╔══██╗██╔══╝  ██║╚██╗██║██╔══██║
    ██║  ██║██║  ██║███████╗██║ ╚████║██║  ██║
    ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝
ART
    echo -e "${C_RESET}"
fi

echo -e "${C_DIM}────────────────────────────────────────────${C_RESET}"
echo -e "${C_HEADER}  ARENA${C_RESET} ${C_LABEL}— Hacker Dashboard for Claude Code${C_RESET}"
echo -e "${C_LABEL}  Theme: ${C_VALUE}${THEME_NAME}${C_RESET}"
echo -e "${C_LABEL}  Time:  ${C_VALUE}$(date '+%Y-%m-%d %H:%M:%S')${C_RESET}"
echo -e "${C_DIM}────────────────────────────────────────────${C_RESET}"
echo ""
echo -e "${C_DIM}  Prefix: Ctrl+A  |  Prefix+T: Cycle themes${C_RESET}"
echo -e "${C_DIM}  Alt+Arrows: Navigate  |  Prefix+f: Zoom${C_RESET}"
echo -e "${C_DIM}  Prefix+0: Main pane  |  Prefix+C: Clear logs${C_RESET}"
echo ""

sleep 2
