#!/usr/bin/env bash
set -euo pipefail

# ─── Install Starship prompt ───

BIN_DIR="$HOME/.local/bin"

# 1. Check if starship is already installed
if command -v starship &>/dev/null; then
    echo "==> Starship already installed at $(command -v starship), skipping"
    exit 0
fi

# 2. Check if curl is available
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed. Please install curl first and re-run this script."
    exit 1
fi

# 3. Ensure ~/.local/bin exists
mkdir -p "$BIN_DIR"

# 4. Install starship via official install script
echo "==> Installing Starship to $BIN_DIR..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$BIN_DIR"

echo "==> Done! Starship installed to $BIN_DIR"
echo "==> Make sure $BIN_DIR is in your PATH"
