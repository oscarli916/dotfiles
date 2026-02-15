#!/usr/bin/env bash
set -euo pipefail

# ─── Install opencode ───

# 1. Check if opencode is already installed
if command -v opencode &>/dev/null; then
    echo "==> opencode already installed: $(opencode --version 2>/dev/null || echo 'version unknown'), skipping"
    exit 0
fi

# 2. Check if curl is available
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed. Please install curl first and re-run this script."
    exit 1
fi

# 3. Install opencode via official install script
#    --no-modify-path  : don't modify shell config files (.zshrc, .bashrc, etc.)
echo "==> Installing opencode..."
curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path

# 4. Verify
if command -v opencode &>/dev/null; then
    echo "==> opencode installed successfully: $(opencode --version 2>/dev/null || echo 'version unknown')"
else
    echo "==> opencode installed to ~/.opencode/bin"
    echo "    Note: Not adding to PATH (--no-modify-path enabled)"
    echo "    Add manually if needed: export PATH=\"\$HOME/.opencode/bin:\$PATH\""
fi

echo "==> Done!"
