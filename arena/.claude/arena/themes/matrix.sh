#!/usr/bin/env bash
# Arena Theme: Matrix Green — green-on-black classic hacker
# Usage: source this file to set theme color variables

THEME_NAME="Matrix Green"

# tmux status bar colors
TMUX_STATUS_BG="black"
TMUX_STATUS_FG="green"
TMUX_STATUS_LEFT_BG="colour22"
TMUX_STATUS_LEFT_FG="colour46"
TMUX_WINDOW_BG="black"
TMUX_WINDOW_FG="colour34"
TMUX_WINDOW_ACTIVE_BG="colour22"
TMUX_WINDOW_ACTIVE_FG="colour46"
TMUX_PANE_BORDER="colour22"
TMUX_PANE_ACTIVE_BORDER="colour46"
TMUX_MESSAGE_BG="black"
TMUX_MESSAGE_FG="colour46"

# ANSI escape color codes for scripts
C_RESET='\033[0m'
C_HEADER='\033[1;38;5;46m'        # Bright green bold — headers/titles
C_LABEL='\033[38;5;34m'           # Medium green — labels
C_VALUE='\033[1;38;5;82m'         # Light green bold — values/data
C_DIM='\033[38;5;22m'             # Dark green — separators/dim text
C_ACCENT='\033[1;38;5;46m'        # Bright green — highlights
C_ACTIVE='\033[1;38;5;46m'        # Bright green — active indicators
C_IDLE='\033[38;5;34m'            # Medium green — idle indicators
C_STANDBY='\033[38;5;22m'         # Dark green — standby indicators
C_ERROR='\033[1;38;5;196m'        # Red — errors
C_WARN='\033[1;38;5;226m'         # Yellow — warnings
C_OK='\033[1;38;5;46m'            # Bright green — success
C_BANNER='\033[1;38;5;46m'        # Bright green — ASCII banner
C_BORDER='\033[38;5;22m'          # Dark green — borders
C_BG='\033[48;5;0m'               # Black background
C_SEPARATOR='\033[38;5;28m'       # Green separator lines
