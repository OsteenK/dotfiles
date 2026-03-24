#!/usr/bin/env bash
# monitor.sh — 4-pane system monitoring dashboard
set -euo pipefail

SESSION="Monitor"

tmux new-session -d -s "$SESSION" -c "$HOME"

# Layout:
# ┌──────────────────────────┬────────────┐
# │     HTOP                 │  DOCKER    │
# ├──────────────────────────┼────────────┤
# │     LOGS (journalctl)    │  NETWORK   │
# └──────────────────────────┴────────────┘

# Split horizontal: top/bottom
tmux split-window -t "$SESSION" -v -l 50%

# Split top row: htop | docker
tmux select-pane -t "$SESSION".1
tmux split-window -t "$SESSION" -h -l 40%

# Split bottom row: logs | network
tmux select-pane -t "$SESSION".3
tmux split-window -t "$SESSION" -h -l 40%

# Pane 1: htop
tmux send-keys -t "$SESSION".1 "htop" Enter

# Pane 2: Docker
tmux send-keys -t "$SESSION".2 "watch -n5 'docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\" 2>/dev/null || echo \"Docker not running\"'" Enter

# Pane 3: System logs
tmux send-keys -t "$SESSION".3 "journalctl -f --no-hostname -n 50" Enter

# Pane 4: Network
tmux send-keys -t "$SESSION".4 "watch -n10 'echo \"── Interfaces ──\" && ip -br addr && echo && echo \"── Connections ──\" && ss -tuln | head -20'" Enter

# Select htop pane
tmux select-pane -t "$SESSION".1
