# Arena

**Hacker-style tmux dashboard for Claude Code sessions.**

Arena gives you a multi-pane tmux environment to monitor system resources, git status, and AI agent activity in real time -- all wrapped in hot-swappable terminal color themes.

---

## Screenshots

> _Screenshots coming soon. Launch Arena and see for yourself._

```
┌──────────────────────────┬────────────┐
│                          │  SYSTEM    │
│     MAIN SESSION         │  MONITOR   │
│     (run claude here)    ├────────────┤
│                          │  GIT       │
│                          │  WATCHER   │
├──────────────────────────┴────────────┤
│  ACTIVITY LOG (all agents)            │
└───────────────────────────────────────┘
```

---

## Features

- **4 color themes** with live hot-swapping (no restart required)
- **System monitor** -- CPU, RAM, swap, disk, load average, uptime, network I/O with colored bar graphs
- **Git watcher** -- repo name, branch, commit count, staged/modified/untracked counts, last 10 commits with graph
- **Unified activity log** -- color-coded entries from all agents with status prefixes
- **Dynamic agent panes** -- spawn and despawn per-agent watcher panes on the fly
- **Auto-spawn** -- logging to an agent automatically creates its watcher pane
- **Auto-despawn** -- panes close 5 seconds after a `[DONE]` message
- **Agent status detection** -- ACTIVE / IDLE / STANDBY based on log timestamps
- **ASCII art banner** on startup (supports `toilet`, `figlet`, or built-in block art)
- **Mouse support** enabled by default
- **inotifywait integration** -- agent watchers react instantly to log changes (falls back to polling)
- **Theme cycling** -- switch themes without leaving tmux via keybinding

---

## Requirements

| Dependency | Required | Notes |
|------------|----------|-------|
| `tmux` | Yes | Core requirement |
| `bash` | Yes | All scripts are Bash |
| `coreutils` | Yes | `date`, `truncate`, `nproc`, etc. |
| `procps` | Yes | `top`, `free`, `ps` |
| `iproute2` | Yes | `ip` for network info |
| `git` | Yes | For the git watcher pane |
| `toilet` | No | Better ASCII banner (falls back to `figlet`, then built-in art) |
| `figlet` | No | Alternative ASCII banner |
| `inotifywait` | No | Instant agent log refresh (from `inotify-tools`; falls back to 3s polling) |

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/OsteenK/Arena.git ~/.claude/arena
```

### 2. Make scripts executable

```bash
chmod +x ~/.claude/arena/arena.sh
chmod +x ~/.claude/arena/scripts/*.sh
```

### 3. Add shell aliases and helpers to your `.zshrc` (or `.bashrc`)

```bash
# --- Arena Dashboard ---
alias arena='bash ~/.claude/arena/arena.sh'

# Default icons for known agents
typeset -A ARENA_AGENT_ICONS
ARENA_AGENT_ICONS=(
    logic "🔍"
    ui "🎨"
    linter "🧹"
    innovator "🚀"
    stats-manager "📊"
    manchester "🛡️"
)

arena-log() {
    local agent="${1:?Usage: arena-log <agent> \"message\"}"
    local msg="${2:?Usage: arena-log <agent> \"message\"}"
    local ts
    ts=$(date '+%H:%M:%S')
    local upper
    upper=$(echo "$agent" | tr '[:lower:]' '[:upper:]')
    local log_dir="$HOME/.claude/arena/agents"
    local panes_file="${log_dir}/.panes"
    local scripts="$HOME/.claude/arena/scripts"
    mkdir -p "$log_dir"

    # Write to agent log + unified activity log
    echo "[${ts}] ${msg}" >> "${log_dir}/${agent}.log"
    echo "[${ts}] [${upper}] ${msg}" >> "${log_dir}/activity.log"

    # Auto-spawn pane if arena is running and agent pane doesn't exist
    if tmux has-session -t arena 2>/dev/null; then
        local icon="${ARENA_AGENT_ICONS[$agent]:-●}"
        if [[ ! -f "$panes_file" ]] || ! grep -q "^${agent}=" "$panes_file" 2>/dev/null; then
            bash "${scripts}/agent-spawn.sh" "$agent" "$icon" &>/dev/null &
        fi

        # Auto-despawn after 5s on [DONE] message
        if [[ "$msg" == *"[DONE]"* ]]; then
            ( sleep 5 && bash "${scripts}/agent-despawn.sh" "$agent" &>/dev/null ) &
            disown
        fi
    fi
}

# Manual spawn/despawn helpers
arena-spawn() {
    local agent="${1:?Usage: arena-spawn <agent_name>}"
    local icon="${ARENA_AGENT_ICONS[$agent]:-●}"
    bash "$HOME/.claude/arena/scripts/agent-spawn.sh" "$agent" "$icon"
}

arena-despawn() {
    local agent="${1:?Usage: arena-despawn <agent_name>}"
    bash "$HOME/.claude/arena/scripts/agent-despawn.sh" "$agent"
}
```

### 4. Reload your shell

```bash
source ~/.zshrc
```

---

## Usage

### Launch Arena

```bash
# Default theme (matrix)
arena

# With a specific theme
arena --theme damu
arena --theme cyberpunk
arena --theme mixed
arena -t matrix

# Kill the session
arena --kill
arena -k

# Show help
arena --help
arena -h
```

If an Arena session is already running, `arena` will reattach to it instead of creating a new one.

### Log agent activity

```bash
# Basic logging
arena-log logic "[CHECK] Scanning imports for circular dependencies"
arena-log ui "[FIX] Adjusted sidebar padding on mobile"
arena-log linter "[START] Running ESLint across project"
arena-log logic "[DONE] No issues found"    # auto-despawns pane after 5s

# Manually spawn/despawn agent panes
arena-spawn logic
arena-despawn logic
```

### Status prefixes

The activity log and agent watchers colorize these prefixes:

| Prefix | Meaning | Color |
|--------|---------|-------|
| `[START]` | Task started | Green |
| `[CHECK]` | Checking / inspecting | Label color |
| `[SCAN]` | Scanning | Accent color |
| `[FIX]` | Applying a fix | Yellow/warning |
| `[DONE]` | Task completed | Green |
| `[ERROR]` | Something failed | Red |

---

## Themes

Arena ships with 4 themes. Switch at any time with `Prefix+T` (cycle) or `Prefix+F1`-`F4` (direct select). Theme changes apply instantly to all panes and the tmux status bar.

### Matrix Green (default)

Classic green-on-black hacker aesthetic.

| Element | Color |
|---------|-------|
| Headers | Bright green bold |
| Labels | Medium green |
| Values | Light green bold |
| Borders | Dark green |
| Background | Black |

### Damu Red

Crimson/red palette inspired by Manchester United.

| Element | Color |
|---------|-------|
| Headers | Bright red bold |
| Labels | Medium red |
| Values | Light red/pink bold |
| Borders | Dark red |
| Background | Black |

### Cyberpunk Neon

Neon cyan, magenta, and yellow on dark navy.

| Element | Color |
|---------|-------|
| Headers | Magenta bold |
| Labels | Cyan |
| Values | Yellow bold |
| Borders | Dark purple |
| Background | Dark navy |

### Mixed

Multi-color: cyan headers, green values, red agent highlights, grey accents.

| Element | Color |
|---------|-------|
| Headers | Cyan bold |
| Labels | Light cyan |
| Values | Green bold |
| Agent highlights | Red |
| Borders | Grey |
| Background | Black |

---

## Layout

Arena starts with a 4-pane layout. Agent panes spawn dynamically as needed.

### Core panes (always present)

| Pane | Position | Description |
|------|----------|-------------|
| **Main** | Top-left (large) | Your primary Claude Code session. Run `claude` here. |
| **System Monitor** | Top-right upper | Live CPU, RAM, swap, disk, load average, uptime, network I/O with bar graphs. Refreshes every ~5 seconds. |
| **Git Watcher** | Top-right lower | Repo name, branch, commit count, working tree status (staged/modified/untracked), last 10 commits with graph. Refreshes every ~5 seconds. |
| **Activity Log** | Bottom (full width) | Unified tail of all agent activity. Color-coded by agent name and status prefix. Streams in real time via `tail -f`. |

### Dynamic agent panes

When you call `arena-log <agent> "message"`, a watcher pane for that agent is automatically spawned in a middle column between Main and System/Git. Multiple agents stack vertically. Each agent pane shows:

- Agent name and icon
- Status indicator: **ACTIVE** (activity < 60s), **IDLE** (< 5min), **STANDBY** (> 5min)
- Last 15 log lines with colorized prefixes
- Auto-updates via `inotifywait` or 3-second polling

Agent panes auto-close 5 seconds after a `[DONE]` message is logged.

---

## Key Bindings

Arena uses `Ctrl+A` as the tmux prefix (instead of the default `Ctrl+B`).

| Binding | Action |
|---------|--------|
| `Ctrl+A` | Prefix key |
| `Alt+Arrow` | Navigate between panes (no prefix needed) |
| `Prefix + 0` | Jump to main Claude pane |
| `Prefix + f` | Toggle fullscreen (zoom) on current pane |
| `Prefix + T` | Cycle to next theme |
| `Prefix + F1` | Switch to Matrix Green |
| `Prefix + F2` | Switch to Damu Red |
| `Prefix + F3` | Switch to Cyberpunk Neon |
| `Prefix + F4` | Switch to Mixed |
| `Prefix + C` | Clear all agent logs |

Mouse support is enabled -- click panes to focus, scroll to browse history.

---

## Helper Commands

These shell functions are defined in your `.zshrc` after installation:

```bash
arena                           # Launch or reattach to Arena
arena --theme <name>            # Launch with a specific theme
arena --kill                    # Kill the Arena tmux session
arena-log <agent> "message"     # Log a message (auto-spawns pane)
arena-spawn <agent>             # Manually spawn an agent watcher pane
arena-despawn <agent>           # Manually close an agent watcher pane
```

### Registered agent icons

| Agent | Icon |
|-------|------|
| `logic` | 🔍 |
| `ui` | 🎨 |
| `linter` | 🧹 |
| `innovator` | 🚀 |
| `stats-manager` | 📊 |
| `manchester` | 🛡️ |

Custom agents use `●` as the default icon. Add your own to the `ARENA_AGENT_ICONS` associative array.

---

## Configuration

### Custom themes

Create a new file in `themes/` following the existing pattern. Each theme defines:

- **tmux variables** (`TMUX_STATUS_BG`, `TMUX_PANE_BORDER`, etc.) for the status bar and pane borders
- **ANSI color variables** (`C_HEADER`, `C_LABEL`, `C_VALUE`, etc.) used by all scripts

Example skeleton:

```bash
#!/usr/bin/env bash
THEME_NAME="My Theme"

# tmux colors
TMUX_STATUS_BG="black"
TMUX_STATUS_FG="white"
# ... (see themes/matrix.sh for all variables)

# Script colors
C_RESET='\033[0m'
C_HEADER='\033[1;37m'
# ... (see themes/matrix.sh for all variables)
```

After creating the file, it will be available via `arena --theme mytheme` and appear in the cycle rotation once added to the `THEMES` array in `scripts/theme-switcher.sh`.

### Custom agent icons

Edit the `ARENA_AGENT_ICONS` array in your `.zshrc`:

```bash
ARENA_AGENT_ICONS[myagent]="🤖"
```

### Git watcher directories

The git watcher searches for repositories in this order:

1. Current working directory (if inside a git repo)
2. `~/Desktop/mine/manenos/Nyumba`
3. `~/Desktop/mine/manenos/netcheck`
4. `~/Desktop/mine/manenos/Daraja`

Edit `scripts/git-watcher.sh` to customize the fallback directories.

### tmux settings

Arena's tmux config is in `tmux.conf`. Key settings:

- 256-color + true color enabled
- History limit: 10,000 lines
- Status bar: bottom, updates every 5 seconds
- Escape time: 0 (no delay on Escape key)

---

## Project Structure

```
~/.claude/arena/
├── arena.sh                  # Main launcher (argument parsing, layout, tmux session)
├── tmux.conf                 # Arena-specific tmux configuration and key bindings
├── current_theme             # Stores the name of the active theme (gitignored)
├── .gitignore                # Ignores log files and current_theme
├── themes/
│   ├── matrix.sh             # Matrix Green — green-on-black classic hacker
│   ├── damu.sh               # Damu Red — crimson/red Manchester United palette
│   ├── cyberpunk.sh          # Cyberpunk Neon — cyan/magenta/yellow on dark navy
│   └── mixed.sh              # Mixed — multi-color: cyan, green, red, grey
├── scripts/
│   ├── banner.sh             # ASCII art startup banner (toilet/figlet/fallback)
│   ├── sys-monitor.sh        # System monitor loop (CPU, RAM, disk, network)
│   ├── git-watcher.sh        # Git status and log watcher loop
│   ├── activity-watcher.sh   # Unified activity log tail with color coding
│   ├── agent-watcher.sh      # Per-agent status watcher (parameterized)
│   ├── agent-spawn.sh        # Dynamically create a new agent pane in tmux
│   ├── agent-despawn.sh      # Close a dynamic agent pane
│   └── theme-switcher.sh     # Hot-swap themes at runtime
└── agents/
    ├── activity.log           # Unified log from all agents (gitignored)
    ├── logic.log              # Logic agent log (gitignored)
    ├── ui.log                 # UI agent log (gitignored)
    ├── linter.log             # Linter agent log (gitignored)
    └── .panes                 # Tracks dynamically spawned pane IDs (gitignored)
```

---

## License

MIT License

Copyright (c) 2026 OsteenK

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## Author

**OsteenK** -- [github.com/OsteenK](https://github.com/OsteenK)
