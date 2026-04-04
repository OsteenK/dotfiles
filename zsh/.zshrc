# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# --- My Custom Aliases ---

# --- Navigation ---
# NOTE: Your original 'TEST' alias was incomplete. Please complete the path.
# alias TEST='cd "/home/x/WORK/ONFONMOBILE/OnfonMobile(fatherfolder)/WORK_V1/onfonv1-front&bac/onfonmobile-????"'
alias WORK='cd ~/Work/Dev'

# --- System Management ---
# CORRECTED: Removed the redundant 'sudo sudo'. One sudo is enough.
alias updateall='sudo nala update && sudo nala upgrade'

# CAUTION: These are powerful. Consider longer names like 'poweroffnow' to prevent accidents.
alias shutdownnow='sudo shutdown now'
alias rebootnow='sudo reboot'

# --- Application & Config Shortcuts ---
# CORRECTED: Used '~' for the home directory and assumed you want to edit a specific file.
# If 'config' is a directory, this will open it in nvim's file explorer.
alias vimconfig='nvim ~/.config/nvim/lua/config/init.lua' # Or options.lua, etc.
alias n='nvim'
alias cat='batcat'

# Quick ask Claude: ?? <question>
??() { claude -p "$*"; }
alias db='dbeaver-ce'
alias fls='yazi' # Assuming yazi is your file manager
alias TEST='cd ~/Work/Dev/onfonv1-front\&bac/onfonmobile-support'
alias WORK='cd ~/Work/Dev'
alias x='sudo  sudo nala update &&  sudo nala upgrade'
alias 1='sudo shutdown now'
alias 2='sudo reboot'
alias lit='xset led on'

# --- Work & Tools ---
# CORRECTED: An alias must be a command. This now executes the client.
alias AWS='/opt/awsvpnclient/AWS VPN Client'
alias jupiter='source myenv/bin/activate'
alias wall='cmatrix -C red -Br -s'
# --- Workspace Picker (tmux) ---
alias ws='~/.local/bin/ws'
alias wsk='ws KEportal'
alias wsc='ws Claude'
alias wsm='ws Manenos'

# IMPROVED: A function is better for your fortivpn alias.
# This lets you provide a username, or it defaults to 'okimanzi'.
# Usage: forti              (uses okimanzi)
# Usage: forti otheruser    (uses otheruser)
forti() {
    local user=${1:-okimanzi} # Use the first argument ($1), or 'okimanzi' if not provided
    sudo openfortivpn 197.248.3.196:40443 --username="$user" --trusted-cert 482700c33868b48eebf23bfb23b2e7dea601632d2fdf20e585f8a235f43fc98e

}
export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/go/bin:$PATH"

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

    # Write to log files
    echo "[${ts}] ${msg}" >> "${log_dir}/${agent}.log"
    echo "[${ts}] [${upper}] ${msg}" >> "${log_dir}/activity.log"

    # Auto-spawn pane if arena is running and agent pane doesn't exist
    if tmux has-session -t arena 2>/dev/null; then
        local icon="${ARENA_AGENT_ICONS[$agent]:-●}"
        # Spawn pane if not already tracked (or dead)
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

# --- Docker Sandbox ---
alias sandbox='docker compose -f ~/.claude/sandbox/docker-compose.yml run --rm claude-sandbox'
