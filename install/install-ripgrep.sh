#!/usr/bin/env bash
set -euo pipefail

# ─── Install ripgrep (rg) ───

BIN_DIR="$HOME/.local/bin"
VERSION="15.1.0"

# 1. Check if ripgrep is already installed
if command -v rg &>/dev/null; then
    echo "==> ripgrep already installed at $(command -v rg), skipping"
    exit 0
fi

# 2. Check if curl is available
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed. Please install curl first and re-run this script."
    exit 1
fi

# 3. Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64)  ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    armv7*)  ARCH="arm" ;;
    i686)    ARCH="i686" ;;
    *)       echo "Error: Unsupported architecture: $ARCH"; exit 1 ;;
esac

case "$OS" in
    linux)
        # x86_64 uses musl, other architectures use gnu
        if [ "$ARCH" = "x86_64" ]; then
            PLATFORM="unknown-linux-musl"
        else
            PLATFORM="unknown-linux-gnu"
        fi
        ;;
    darwin)  PLATFORM="apple-darwin" ;;
    freebsd) PLATFORM="unknown-freebsd" ;;
    *)       echo "Error: Unsupported OS: $OS"; exit 1 ;;
esac

# 4. Get latest release URL
RELEASE_URL="https://github.com/BurntSushi/ripgrep/releases/download/${VERSION}/ripgrep-${VERSION}-${ARCH}-${PLATFORM}.tar.gz"
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# 5. Download and extract
echo "==> Downloading ripgrep for $OS $ARCH..."
curl -L -sS "$RELEASE_URL" -o "$TEMP_DIR/ripgrep.tar.gz"

echo "==> Extracting..."
tar -xzf "$TEMP_DIR/ripgrep.tar.gz" -C "$TEMP_DIR"

# 6. Install binary
mkdir -p "$BIN_DIR"
echo "==> Installing ripgrep to $BIN_DIR..."
cp "$TEMP_DIR"/*/rg "$BIN_DIR/"
chmod +x "$BIN_DIR/rg"

echo "==> Done! ripgrep installed to $BIN_DIR"
echo "==> Make sure $BIN_DIR is in your PATH"
echo "==> Verify with: rg --version"
