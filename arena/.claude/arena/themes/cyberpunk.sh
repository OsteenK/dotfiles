#!/usr/bin/env bash
# Arena Theme: Cyberpunk Neon — cyan/magenta/yellow on dark navy
# Usage: source this file to set theme color variables

THEME_NAME="Cyberpunk Neon"

# tmux status bar colors
TMUX_STATUS_BG="colour17"
TMUX_STATUS_FG="colour51"
TMUX_STATUS_LEFT_BG="colour93"
TMUX_STATUS_LEFT_FG="colour231"
TMUX_WINDOW_BG="colour17"
TMUX_WINDOW_FG="colour45"
TMUX_WINDOW_ACTIVE_BG="colour93"
TMUX_WINDOW_ACTIVE_FG="colour231"
TMUX_PANE_BORDER="colour57"
TMUX_PANE_ACTIVE_BORDER="colour201"
TMUX_MESSAGE_BG="colour17"
TMUX_MESSAGE_FG="colour51"

# ANSI escape color codes for scripts
C_RESET='\033[0m'
C_HEADER='\033[1;38;5;201m'       # Magenta bold — headers/titles
C_LABEL='\033[38;5;51m'           # Cyan — labels
C_VALUE='\033[1;38;5;226m'        # Yellow bold — values/data
C_DIM='\033[38;5;57m'             # Dark purple — separators/dim text
C_ACCENT='\033[1;38;5;51m'        # Cyan — highlights
C_ACTIVE='\033[1;38;5;201m'       # Magenta — active indicators
C_IDLE='\033[38;5;45m'            # Light cyan — idle indicators
C_STANDBY='\033[38;5;57m'         # Dark purple — standby indicators
C_ERROR='\033[1;38;5;196m'        # Red — errors
C_WARN='\033[1;38;5;208m'         # Orange — warnings
C_OK='\033[1;38;5;46m'            # Green — success
C_BANNER='\033[1;38;5;201m'       # Magenta — ASCII banner
C_BORDER='\033[38;5;57m'          # Dark purple — borders
C_BG='\033[48;5;17m'              # Dark navy background
C_SEPARATOR='\033[38;5;93m'       # Purple separator lines
