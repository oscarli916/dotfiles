#!/usr/bin/env bash
set -euo pipefail

# ─── Install lsd (LSDeluxe) ───

# 1. Check if lsd is already installed
if command -v lsd &>/dev/null; then
    echo "==> lsd already installed: $(lsd --version), skipping"
    exit 0
fi

# 2. Install via package manager
echo "==> Detecting package manager..."

if command -v apt &>/dev/null; then
    echo "==> Found apt (Debian/Ubuntu)"
    sudo apt update && sudo apt install -y lsd
elif command -v dnf &>/dev/null; then
    echo "==> Found dnf (Fedora/RHEL)"
    sudo dnf install -y lsd
elif command -v pacman &>/dev/null; then
    echo "==> Found pacman (Arch Linux)"
    sudo pacman -S --noconfirm lsd
else
    echo "Error: No supported package manager found (apt, dnf, pacman)."
    echo "Please install lsd manually: https://github.com/lsd-rs/lsd#installation"
    exit 1
fi

# 3. Verify
if command -v lsd &>/dev/null; then
    echo "==> lsd installed successfully: $(lsd --version)"
else
    echo "Error: lsd installation failed."
    exit 1
fi

echo "==> Done!"
