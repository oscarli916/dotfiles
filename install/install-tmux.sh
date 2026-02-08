#!/usr/bin/env bash
set -euo pipefail

# ─── Install tmux from source + TPM ───

TMUX_VERSION="3.5a"
PREFIX="$HOME/.local"
TPM_DIR="$HOME/.tmux/plugins/tpm"

# 1. Check if tmux is already installed
if command -v tmux &>/dev/null; then
    echo "==> tmux already installed: $(tmux -V), skipping"
else
    # 2. Install build dependencies
    echo "==> Installing build dependencies..."

    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y build-essential libevent-dev libncurses-dev
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y gcc make libevent-devel ncurses-devel
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm base-devel libevent ncurses
    else
        echo "Error: No supported package manager found. Install build dependencies manually."
        exit 1
    fi

    # 3. Download and extract release tarball
    TARBALL="tmux-${TMUX_VERSION}.tar.gz"
    DOWNLOAD_URL="https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/${TARBALL}"
    BUILD_DIR="$(mktemp -d)"

    echo "==> Downloading tmux ${TMUX_VERSION}..."
    curl -fsSL "$DOWNLOAD_URL" -o "$BUILD_DIR/$TARBALL"

    echo "==> Extracting..."
    tar -xzf "$BUILD_DIR/$TARBALL" -C "$BUILD_DIR"

    # 4. Build and install
    echo "==> Building tmux ${TMUX_VERSION} (prefix: $PREFIX)..."
    cd "$BUILD_DIR/tmux-${TMUX_VERSION}"
    ./configure --prefix="$PREFIX"
    make
    make install

    # 5. Clean up
    echo "==> Cleaning up build artifacts..."
    rm -rf "$BUILD_DIR"

    # 6. Verify
    if command -v tmux &>/dev/null; then
        echo "==> tmux installed successfully: $(tmux -V)"
    else
        echo "==> tmux built and installed to $PREFIX/bin/tmux"
        echo "==> Make sure $PREFIX/bin is in your PATH"
    fi
fi

# 7. Install TPM
if [ -d "$TPM_DIR" ]; then
    echo "==> TPM already installed at $TPM_DIR, skipping"
else
    echo "==> Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "==> TPM installed. Press prefix + I inside tmux to install plugins."
fi

echo "==> Done!"
