#!/usr/bin/env bash

set -euo pipefail

# Check if zsh is already installed
if command -v zsh &>/dev/null; then
    echo "zsh is already installed: $(zsh --version)"
    exit 0
fi

# Determine if sudo is needed
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo &>/dev/null; then
        SUDO="sudo"
    else
        echo "Error: requires root privileges. Run as root or install sudo."
        exit 1
    fi
fi

# Detect package manager and install zsh
if command -v apt-get &>/dev/null; then
    $SUDO apt-get update -y && $SUDO apt-get install -y zsh
elif command -v dnf &>/dev/null; then
    $SUDO dnf install -y zsh
elif command -v yum &>/dev/null; then
    $SUDO yum install -y zsh
elif command -v pacman &>/dev/null; then
    $SUDO pacman -Sy --noconfirm zsh
elif command -v zypper &>/dev/null; then
    $SUDO zypper install -y zsh
elif command -v apk &>/dev/null; then
    $SUDO apk add zsh
elif command -v xbps-install &>/dev/null; then
    $SUDO xbps-install -Sy zsh
elif command -v emerge &>/dev/null; then
    $SUDO emerge --ask=n app-shells/zsh
elif command -v nix-env &>/dev/null; then
    nix-env -iA nixpkgs.zsh
else
    echo "Error: no supported package manager found."
    exit 1
fi

# Verify installation
if ! command -v zsh &>/dev/null; then
    echo "Error: zsh installation failed."
    exit 1
fi

echo "zsh installed: $(zsh --version)"

# Set zsh as default shell
ZSH_PATH="$(command -v zsh)"
if [ -f /etc/shells ] && ! grep -qxF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | $SUDO tee -a /etc/shells >/dev/null
fi

if command -v chsh &>/dev/null; then
    chsh -s "$ZSH_PATH"
    echo "Default shell set to $ZSH_PATH. Log out and back in to use zsh."
else
    echo "chsh not found. Manually set your shell: usermod -s $ZSH_PATH $(whoami)"
fi
