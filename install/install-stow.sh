#!/usr/bin/env bash
set -euo pipefail

# ─── Install GNU Stow and symlink dotfiles ───

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Detecting package manager..."

if command -v apt &>/dev/null; then
	echo "==> Found apt (Debian/Ubuntu)"
	sudo apt update && sudo apt install -y stow
elif command -v dnf &>/dev/null; then
	echo "==> Found dnf (Fedora/RHEL)"
	sudo dnf install -y stow
elif command -v pacman &>/dev/null; then
	echo "==> Found pacman (Arch Linux)"
	sudo pacman -S --noconfirm stow
else
	echo "Error: No supported package manager found (apt, dnf, pacman)."
	echo "Please install GNU Stow manually and re-run this script."
	exit 1
fi

echo "==> Stow installed successfully"
echo "==> Symlinking dotfiles from $DOTFILES_DIR to $HOME..."

stow -v -t "$HOME" -d "$DOTFILES_DIR" .

echo "==> Done! Dotfiles are now symlinked."
