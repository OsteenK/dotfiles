#!/usr/bin/env bash
# Arena Theme: Mixed — green for system, red for agents, cyan for headers
# Usage: source this file to set theme color variables

THEME_NAME="Mixed"

# tmux status bar colors
TMUX_STATUS_BG="black"
TMUX_STATUS_FG="colour51"
TMUX_STATUS_LEFT_BG="colour24"
TMUX_STATUS_LEFT_FG="colour231"
TMUX_WINDOW_BG="black"
TMUX_WINDOW_FG="colour51"
TMUX_WINDOW_ACTIVE_BG="colour24"
TMUX_WINDOW_ACTIVE_FG="colour231"
TMUX_PANE_BORDER="colour240"
TMUX_PANE_ACTIVE_BORDER="colour51"
TMUX_MESSAGE_BG="black"
TMUX_MESSAGE_FG="colour51"

# ANSI escape color codes for scripts
C_RESET='\033[0m'
C_HEADER='\033[1;38;5;51m'        # Cyan bold — headers/titles
C_LABEL='\033[38;5;45m'           # Light cyan — labels
C_VALUE='\033[1;38;5;46m'         # Green bold — system values
C_DIM='\033[38;5;240m'            # Grey — separators/dim text
C_ACCENT='\033[1;38;5;196m'       # Red — agent highlights
C_ACTIVE='\033[1;38;5;196m'       # Red — active agent indicators
C_IDLE='\033[38;5;167m'           # Medium red — idle indicators
C_STANDBY='\033[38;5;240m'        # Grey — standby indicators
C_ERROR='\033[1;38;5;196m'        # Red — errors
C_WARN='\033[1;38;5;226m'         # Yellow — warnings
C_OK='\033[1;38;5;46m'            # Green — success
C_BANNER='\033[1;38;5;51m'        # Cyan — ASCII banner
C_BORDER='\033[38;5;240m'         # Grey — borders
C_BG='\033[48;5;0m'               # Black background
C_SEPARATOR='\033[38;5;238m'      # Dark grey separator lines
