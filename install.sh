#!/usr/bin/env bash
# install.sh — Symlink installer for dotfiles (stow-compatible layout)
# Each package dir mirrors $HOME structure. Creates symlinks from dotfiles → $HOME.
set -euo pipefail

DOTFILES="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles.backup.$(date +%Y%m%d_%H%M%S)"

# Packages to install
PACKAGES=(tmux bin zsh nvim alacritty yazi arena)

backup_and_link() {
    local src="$1"
    local dest="$2"

    # If destination exists and is NOT already a symlink to our source
    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ -L "$dest" ]] && [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
            return 0  # Already linked correctly
        fi
        # Backup
        local backup_path="${BACKUP_DIR}/${dest#$HOME/}"
        mkdir -p "$(dirname "$backup_path")"
        mv "$dest" "$backup_path"
        echo "  Backed up: $dest → $backup_path"
    fi

    # Create parent dir if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -sf "$src" "$dest"
    echo "  Linked: $dest → $src"
}

echo "╔══════════════════════════════════╗"
echo "║   Dotfiles Installer             ║"
echo "╚══════════════════════════════════╝"
echo ""

for pkg in "${PACKAGES[@]}"; do
    pkg_dir="${DOTFILES}/${pkg}"
    if [[ ! -d "$pkg_dir" ]]; then
        echo "⚠ Package '$pkg' not found, skipping"
        continue
    fi

    echo "📦 Installing: $pkg"

    # Find all files in the package (following the stow layout)
    while IFS= read -r -d '' file; do
        # Get relative path within the package
        rel="${file#$pkg_dir/}"
        dest="$HOME/$rel"
        backup_and_link "$file" "$dest"
    done < <(find "$pkg_dir" -type f -print0)

    # Also link directories that are leaf directories (contain files but no subdirs with files)
    # This handles cases like nvim config dirs
done

# Ensure ~/.local/bin is executable
chmod +x "$HOME/.local/bin/ws" 2>/dev/null || true

echo ""
echo "✓ Installation complete!"
if [[ -d "$BACKUP_DIR" ]]; then
    echo "  Backups saved to: $BACKUP_DIR"
fi
echo ""
echo "Next steps:"
echo "  1. Restart your shell or: source ~/.zshrc"
echo "  2. Test: ws --list"
echo "  3. Launch a workspace: ws"
