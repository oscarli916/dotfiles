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

