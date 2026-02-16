#!/usr/bin/env bash
set -euo pipefail

# ─── Master install script ───

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

scripts=(
    "install-stow.sh"
    "install-zsh.sh"
    "install-oh-my-zsh.sh"
    "install-starship.sh"
    "install-fzf.sh"
    "install-lsd.sh"
    "install-tmux.sh"
    "install-nvim.sh"
    "install-opencode.sh"
)

for script in "${scripts[@]}"; do
    echo ""
    echo "=========================================="
    echo "  Running $script"
    echo "=========================================="
    echo ""
    bash "$INSTALL_DIR/$script"
done

echo ""
echo "=========================================="
echo "  All installations complete!"
echo "=========================================="
echo ""
echo "Next steps - verify the following:"
echo ""
echo "1. fzf     - Press Ctrl+R to search command history with fzf"
echo "2. lsd     - Run 'ls' to see colored output with icons"
echo "3. tmux    - Press Ctrl+A then I to install plugins via tpm"
echo "4. nvim    - Open nvim to automatically install dependencies"

