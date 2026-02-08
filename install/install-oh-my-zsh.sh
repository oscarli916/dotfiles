#!/usr/bin/env bash
set -euo pipefail

# ─── Install Oh My Zsh with plugins ───

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 1. Check zsh is installed
if ! command -v zsh &>/dev/null; then
    echo "Error: zsh is not installed. Please install zsh first and re-run this script."
    exit 1
fi

echo "==> zsh found at $(command -v zsh)"

# 2. Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Oh My Zsh already installed, skipping"
else
    echo "==> Installing Oh My Zsh..."
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "==> Oh My Zsh installed successfully"
fi

# 3. Install zsh-autosuggestions plugin
if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
    echo "==> zsh-autosuggestions already installed, skipping"
else
    echo "==> Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
    echo "==> zsh-autosuggestions installed successfully"
fi

# 4. Install zsh-syntax-highlighting plugin
if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
    echo "==> zsh-syntax-highlighting already installed, skipping"
else
    echo "==> Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
    echo "==> zsh-syntax-highlighting installed successfully"
fi

echo "==> Done! Oh My Zsh is ready with autosuggestions and syntax-highlighting plugins."
