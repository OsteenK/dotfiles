#!/usr/bin/env bash
# Arena — Git log + branch watcher

ARENA_DIR="$HOME/.claude/arena"
THEME_FILE="${ARENA_DIR}/current_theme"

reload_theme() {
    local theme
    theme=$(cat "$THEME_FILE" 2>/dev/null || echo "matrix")
    source "${ARENA_DIR}/themes/${theme}.sh"
}

# Find git repo — check CWD, then common project dirs
find_git_dir() {
    # Check if we're in a git repo
    if git rev-parse --show-toplevel &>/dev/null; then
        git rev-parse --show-toplevel
        return 0
    fi

    # Check common project directories
    for dir in ~/Desktop/mine/manenos/Nyumba ~/Desktop/mine/manenos/netcheck ~/Desktop/mine/manenos/Daraja; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
    done

    return 1
}

while true; do
    reload_theme
    clear

    echo -e "${C_HEADER}  ╔══════════════════════════════╗${C_RESET}"
    echo -e "${C_HEADER}  ║      📁  GIT WATCHER         ║${C_RESET}"
    echo -e "${C_HEADER}  ╚══════════════════════════════╝${C_RESET}"
    echo ""

    git_dir=$(find_git_dir)

    if [[ -z "$git_dir" ]]; then
        echo -e "  ${C_DIM}No git repository found${C_RESET}"
        echo -e "  ${C_DIM}cd into a git repo to see info${C_RESET}"
        sleep 5
        continue
    fi

    cd "$git_dir" || continue

    repo_name=$(basename "$git_dir")
    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    total_commits=$(git rev-list --count HEAD 2>/dev/null || echo "?")

    echo -e "  ${C_LABEL}REPO  ${C_RESET} ${C_VALUE}${repo_name}${C_RESET}"
    echo -e "  ${C_LABEL}BRANCH${C_RESET} ${C_ACCENT}${branch}${C_RESET}"
    echo -e "  ${C_LABEL}TOTAL ${C_RESET} ${C_VALUE}${total_commits} commits${C_RESET}"

    # Status summary
    staged=$(git diff --cached --numstat 2>/dev/null | wc -l)
    modified=$(git diff --numstat 2>/dev/null | wc -l)
    untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)

    echo ""
    echo -e "  ${C_SEPARATOR}──────────────────────────────${C_RESET}"
    echo -e "  ${C_HEADER}  STATUS${C_RESET}"

    if (( staged > 0 )); then
        echo -e "  ${C_OK}  ● ${staged} staged${C_RESET}"
    fi
    if (( modified > 0 )); then
        echo -e "  ${C_WARN}  ◐ ${modified} modified${C_RESET}"
    fi
    if (( untracked > 0 )); then
        echo -e "  ${C_DIM}  ○ ${untracked} untracked${C_RESET}"
    fi
    if (( staged == 0 && modified == 0 && untracked == 0 )); then
        echo -e "  ${C_OK}  ✓ Clean working tree${C_RESET}"
    fi

    # Recent commits
    echo ""
    echo -e "  ${C_SEPARATOR}──────────────────────────────${C_RESET}"
    echo -e "  ${C_HEADER}  LOG${C_RESET}"
    echo ""

    git log --oneline --graph --decorate -10 2>/dev/null | while IFS= read -r line; do
        # Colorize: hash in accent, rest in value
        hash=$(echo "$line" | grep -oP '[a-f0-9]{7}' | head -1)
        if [[ -n "$hash" ]]; then
            colored=$(echo "$line" | sed "s/${hash}/$(printf "${C_ACCENT}")${hash}$(printf "${C_RESET}${C_VALUE}")/")
            echo -e "  ${C_VALUE}${colored}${C_RESET}"
        else
            echo -e "  ${C_DIM}${line}${C_RESET}"
        fi
    done

    echo ""
    echo -e "  ${C_DIM}Updated: $(date '+%H:%M:%S')${C_RESET}"

    sleep 5
done
