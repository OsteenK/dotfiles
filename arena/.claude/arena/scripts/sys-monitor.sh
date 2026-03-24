#!/usr/bin/env bash
# Arena — System monitor: CPU, RAM, disk, network stats loop

ARENA_DIR="$HOME/.claude/arena"
THEME_FILE="${ARENA_DIR}/current_theme"

reload_theme() {
    local theme
    theme=$(cat "$THEME_FILE" 2>/dev/null || echo "matrix")
    source "${ARENA_DIR}/themes/${theme}.sh"
}

# Bar graph generator: usage% -> colored bar
bar_graph() {
    local pct=$1 width=20
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local color="$C_OK"
    (( pct > 80 )) && color="$C_ERROR"
    (( pct > 60 && pct <= 80 )) && color="$C_WARN"
    printf "${color}"
    printf '█%.0s' $(seq 1 $filled 2>/dev/null)
    printf "${C_DIM}"
    printf '░%.0s' $(seq 1 $empty 2>/dev/null)
    printf "${C_RESET}"
}

while true; do
    reload_theme
    clear

    echo -e "${C_HEADER}  ╔══════════════════════════════╗${C_RESET}"
    echo -e "${C_HEADER}  ║     📊  SYSTEM MONITOR       ║${C_RESET}"
    echo -e "${C_HEADER}  ╚══════════════════════════════╝${C_RESET}"
    echo ""

    # CPU
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
    cpu_usage=$(( 100 - ${cpu_idle:-0} ))
    echo -e "  ${C_LABEL}CPU ${C_RESET} $(bar_graph $cpu_usage) ${C_VALUE}${cpu_usage}%${C_RESET}"

    # RAM
    read -r total used available <<< "$(free -m | awk '/Mem:/ {print $2, $3, $7}')"
    ram_pct=$(( used * 100 / total ))
    total_g=$(awk "BEGIN {printf \"%.1f\", ${total}/1024}")
    used_g=$(awk "BEGIN {printf \"%.1f\", ${used}/1024}")
    echo -e "  ${C_LABEL}RAM ${C_RESET} $(bar_graph $ram_pct) ${C_VALUE}${used_g}G${C_RESET}${C_DIM}/${total_g}G${C_RESET}"

    # Swap
    read -r stotal sused <<< "$(free -m | awk '/Swap:/ {print $2, $3}')"
    if (( stotal > 0 )); then
        swap_pct=$(( sused * 100 / stotal ))
        sused_g=$(awk "BEGIN {printf \"%.1f\", ${sused}/1024}")
        stotal_g=$(awk "BEGIN {printf \"%.1f\", ${stotal}/1024}")
        echo -e "  ${C_LABEL}SWP ${C_RESET} $(bar_graph $swap_pct) ${C_VALUE}${sused_g}G${C_RESET}${C_DIM}/${stotal_g}G${C_RESET}"
    fi

    # Disk
    read -r dsize dused dpct <<< "$(df -h / | awk 'NR==2 {print $2, $3, $5}')"
    dpct_num=${dpct%\%}
    echo -e "  ${C_LABEL}DSK ${C_RESET} $(bar_graph $dpct_num) ${C_VALUE}${dused}${C_RESET}${C_DIM}/${dsize}${C_RESET}"

    echo ""
    echo -e "  ${C_SEPARATOR}──────────────────────────────${C_RESET}"
    echo ""

    # Load average
    loadavg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
    nproc=$(nproc)
    echo -e "  ${C_LABEL}LOAD${C_RESET}  ${C_VALUE}${loadavg}${C_RESET} ${C_DIM}(${nproc} cores)${C_RESET}"

    # Uptime
    uptime_str=$(uptime -p 2>/dev/null | sed 's/up //')
    echo -e "  ${C_LABEL}UP  ${C_RESET}  ${C_VALUE}${uptime_str}${C_RESET}"

    # Network
    echo ""
    echo -e "  ${C_SEPARATOR}──────────────────────────────${C_RESET}"
    echo -e "  ${C_HEADER}  NET${C_RESET}"

    # Get active interface
    iface=$(ip route | awk '/default/ {print $5; exit}')
    if [[ -n "$iface" ]]; then
        ip_addr=$(ip -4 addr show "$iface" | awk '/inet / {print $2}' | cut -d/ -f1)
        echo -e "  ${C_LABEL}IF  ${C_RESET}  ${C_VALUE}${iface}${C_RESET}"
        echo -e "  ${C_LABEL}IP  ${C_RESET}  ${C_VALUE}${ip_addr}${C_RESET}"

        # RX/TX bytes
        rx1=$(cat /sys/class/net/"$iface"/statistics/rx_bytes 2>/dev/null || echo 0)
        tx1=$(cat /sys/class/net/"$iface"/statistics/tx_bytes 2>/dev/null || echo 0)
        sleep 1
        rx2=$(cat /sys/class/net/"$iface"/statistics/rx_bytes 2>/dev/null || echo 0)
        tx2=$(cat /sys/class/net/"$iface"/statistics/tx_bytes 2>/dev/null || echo 0)
        rx_rate=$(( (rx2 - rx1) / 1024 ))
        tx_rate=$(( (tx2 - tx1) / 1024 ))
        echo -e "  ${C_LABEL}RX  ${C_RESET}  ${C_VALUE}${rx_rate} KB/s${C_RESET}"
        echo -e "  ${C_LABEL}TX  ${C_RESET}  ${C_VALUE}${tx_rate} KB/s${C_RESET}"
    else
        echo -e "  ${C_DIM}  No active interface${C_RESET}"
    fi

    # Processes
    echo ""
    echo -e "  ${C_SEPARATOR}──────────────────────────────${C_RESET}"
    procs=$(ps aux --no-heading | wc -l)
    echo -e "  ${C_LABEL}PROCS${C_RESET} ${C_VALUE}${procs}${C_RESET}"

    # Timestamp
    echo ""
    echo -e "  ${C_DIM}Updated: $(date '+%H:%M:%S')${C_RESET}"

    sleep 4
done
