#!/usr/bin/env bash
set -euo pipefail

# ─── Install opencode ───

# 1. Skip if opencode v2 is already installed
if command -v opencode &>/dev/null; then
    installed_version=$(opencode --version 2>/dev/null || true)
    if [[ "$installed_version" == 2.* ]]; then
        echo "==> opencode v2 already installed: $installed_version, skipping"
        exit 0
    fi

    echo "==> Found opencode ${installed_version:-version unknown}; upgrading to v2..."
fi

# 2. Check if curl is available
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed. Please install curl first and re-run this script."
    exit 1
fi

# 3. Install opencode v2 via official install script
#    --no-modify-path  : don't modify shell config files (.zshrc, .bashrc, etc.)
echo "==> Installing opencode v2..."
curl -fsSL https://opencode.ai/v2/install | bash -s -- --no-modify-path

# 4. Verify
if command -v opencode &>/dev/null; then
    installed_version=$(opencode --version 2>/dev/null || true)
    if [[ "$installed_version" != 2.* ]]; then
        echo "Error: Expected opencode v2, but found ${installed_version:-version unknown}."
        exit 1
    fi

    echo "==> opencode installed successfully: $installed_version"
else
    echo "Error: opencode was installed to ~/.opencode/bin but is not available on PATH."
    echo "Add it with: export PATH=\"\$HOME/.opencode/bin:\$PATH\""
    exit 1
fi

echo "==> Done!"
