#!/usr/bin/env bash
set -euo pipefail

# ─── Install mise ───

BIN_DIR="$HOME/.local/bin"
MISE_BIN="$BIN_DIR/mise"

# 1. Check if mise is already installed
if command -v mise &>/dev/null; then
    echo "==> mise already installed: $(mise --version 2>/dev/null || echo 'version unknown'), skipping"
    exit 0
fi

if [ -x "$MISE_BIN" ]; then
    echo "==> mise already installed at $MISE_BIN: $("$MISE_BIN" --version 2>/dev/null || echo 'version unknown'), skipping"
    exit 0
fi

# 2. Check if curl is available
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed. Please install curl first and re-run this script."
    exit 1
fi

# 3. Ensure ~/.local/bin exists
mkdir -p "$BIN_DIR"

# 4. Install mise via official install script
#    MISE_INSTALL_PATH : install binary to ~/.local/bin/mise
#    MISE_INSTALL_HELP : disable post-install shell instructions (better for automation logs)
echo "==> Installing mise to $MISE_BIN..."
curl -fsSL https://mise.run | env \
    MISE_INSTALL_PATH="$MISE_BIN" \
    MISE_INSTALL_HELP=0 \
    sh

# 5. Verify
if [ -x "$MISE_BIN" ]; then
    echo "==> mise installed successfully: $("$MISE_BIN" --version 2>/dev/null || echo 'version unknown')"
    echo "==> Installed at: $MISE_BIN"
else
    echo "Error: mise installation failed (binary not found at $MISE_BIN)."
    exit 1
fi

echo "==> Done! Make sure $BIN_DIR is in your PATH"
