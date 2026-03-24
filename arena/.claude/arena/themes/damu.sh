#!/usr/bin/env bash
# Arena Theme: Damu Red — Man United red/crimson palette
# Usage: source this file to set theme color variables

THEME_NAME="Damu Red"

# tmux status bar colors
TMUX_STATUS_BG="colour52"
TMUX_STATUS_FG="colour196"
TMUX_STATUS_LEFT_BG="colour124"
TMUX_STATUS_LEFT_FG="colour231"
TMUX_WINDOW_BG="colour52"
TMUX_WINDOW_FG="colour167"
TMUX_WINDOW_ACTIVE_BG="colour124"
TMUX_WINDOW_ACTIVE_FG="colour231"
TMUX_PANE_BORDER="colour88"
TMUX_PANE_ACTIVE_BORDER="colour196"
TMUX_MESSAGE_BG="colour52"
TMUX_MESSAGE_FG="colour196"

# ANSI escape color codes for scripts
C_RESET='\033[0m'
C_HEADER='\033[1;38;5;196m'       # Bright red bold — headers/titles
C_LABEL='\033[38;5;167m'          # Medium red — labels
C_VALUE='\033[1;38;5;217m'        # Light red/pink bold — values/data
C_DIM='\033[38;5;88m'             # Dark red — separators/dim text
C_ACCENT='\033[1;38;5;196m'       # Bright red — highlights
C_ACTIVE='\033[1;38;5;196m'       # Bright red — active indicators
C_IDLE='\033[38;5;167m'           # Medium red — idle indicators
C_STANDBY='\033[38;5;88m'         # Dark red — standby indicators
C_ERROR='\033[1;38;5;226m'        # Yellow — errors (contrast)
C_WARN='\033[1;38;5;208m'         # Orange — warnings
C_OK='\033[1;38;5;46m'            # Green — success
C_BANNER='\033[1;38;5;196m'       # Bright red — ASCII banner
C_BORDER='\033[38;5;88m'          # Dark red — borders
C_BG='\033[48;5;0m'               # Black background
C_SEPARATOR='\033[38;5;124m'      # Red separator lines
