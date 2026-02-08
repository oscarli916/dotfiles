#!/usr/bin/env bash
set -euo pipefail

# ─── Install fzf ───

FZF_DIR="$HOME/.fzf"

# 1. Check if fzf is already installed
if [ -d "$FZF_DIR" ]; then
    echo "==> fzf already installed at $FZF_DIR, skipping"
    exit 0
fi

# 2. Check if git is available
if ! command -v git &>/dev/null; then
    echo "Error: git is not installed. Please install git first and re-run this script."
    exit 1
fi

# 3. Clone fzf
echo "==> Cloning fzf into $FZF_DIR..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"

# 4. Run fzf install script
#    --key-bindings  : enable key bindings (CTRL-T, CTRL-R, ALT-C)
#    --completion    : enable fuzzy completion
#    --no-update-rc  : don't modify shell rc files (stow handles .zshrc)
echo "==> Running fzf install script..."
"$FZF_DIR/install" --key-bindings --completion --no-update-rc

echo "==> Done! fzf installed at $FZF_DIR"
