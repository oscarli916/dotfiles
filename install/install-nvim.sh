#!/usr/bin/env bash
set -euo pipefail

# ─── Install Neovim from source ───

NEOVIM_VERSION="v0.11.4"
PREFIX="$HOME/.local"

# 1. Check if nvim is already installed
if command -v nvim &>/dev/null; then
    echo "==> Neovim already installed: $(nvim --version | head -1), skipping"
    exit 0
fi

# 2. Install build dependencies
echo "==> Installing build dependencies..."

if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y cmake gettext make gcc g++ unzip curl
elif command -v dnf &>/dev/null; then
    sudo dnf install -y cmake gcc make unzip gettext curl gcc-c++
elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm base-devel cmake unzip curl
else
    echo "Error: No supported package manager found. Install build dependencies manually."
    exit 1
fi

# 3. Clone neovim into a temp directory
BUILD_DIR="$(mktemp -d)"

echo "==> Cloning Neovim ${NEOVIM_VERSION}..."
git clone --depth 1 --branch "$NEOVIM_VERSION" https://github.com/neovim/neovim.git "$BUILD_DIR/neovim"

# 4. Build
echo "==> Building Neovim ${NEOVIM_VERSION} (prefix: $PREFIX)..."
cd "$BUILD_DIR/neovim"
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$PREFIX"

# 5. Install
echo "==> Installing Neovim to $PREFIX..."
make install

# 6. Clean up
echo "==> Cleaning up build artifacts..."
rm -rf "$BUILD_DIR"

# 7. Verify
if command -v nvim &>/dev/null; then
    echo "==> Neovim installed successfully: $(nvim --version | head -1)"
else
    echo "==> Neovim built and installed to $PREFIX/bin/nvim"
    echo "==> Make sure $PREFIX/bin is in your PATH"
fi

echo "==> Done!"
