#!/usr/bin/env bash
set -euo pipefail

# ─── Install direnv ───

BIN_DIR="$HOME/.local/bin"
VERSION="2.37.1"

# 1. Check if direnv is already installed
if command -v direnv &>/dev/null; then
	echo "==> direnv already installed at $(command -v direnv), skipping"
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
	x86_64)        ARCH="amd64" ;;
	aarch64|arm64) ARCH="arm64" ;;
	*)             echo "Error: Unsupported architecture: $ARCH"; exit 1 ;;
esac

case "$OS" in
	linux|darwin) ;;
	*) echo "Error: Unsupported OS: $OS"; exit 1 ;;
esac

# 4. Download binary
RELEASE_URL="https://github.com/direnv/direnv/releases/download/v${VERSION}/direnv.${OS}-${ARCH}"

echo "==> Downloading direnv v${VERSION} for ${OS}-${ARCH}..."
mkdir -p "$BIN_DIR"
curl -L -sS "$RELEASE_URL" -o "$BIN_DIR/direnv"
chmod +x "$BIN_DIR/direnv"

echo "==> Done! direnv installed to $BIN_DIR/direnv"
echo "==> Make sure $BIN_DIR is in your PATH"
echo "==> Verify with: direnv --version"
