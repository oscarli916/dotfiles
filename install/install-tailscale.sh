#!/usr/bin/env bash
set -euo pipefail

# ─── Install Tailscale client ───

TRACK="stable"
TAILSCALE_VERSION=""

usage() {
	cat <<'EOF'
Usage: install-tailscale.sh [OPTIONS]

Install Tailscale using the official install script.

Options:
  --track <stable|unstable>  Release track to install (default: stable)
  --version <X.Y.Z>          Pin a specific Tailscale version (optional)
  --help                     Show this help message

Examples:
  bash install/install-tailscale.sh
  bash install/install-tailscale.sh --track unstable
  bash install/install-tailscale.sh --version 1.88.4
  bash install/install-tailscale.sh --track unstable --version 1.88.4
EOF
}

# 1. Parse options
while [[ $# -gt 0 ]]; do
	case "$1" in
		--track)
			if [[ $# -lt 2 ]]; then
				echo "Error: --track requires a value (stable|unstable)."
				exit 1
			fi
			TRACK="$2"
			shift 2
			;;
		--version)
			if [[ $# -lt 2 ]]; then
				echo "Error: --version requires a value (for example: 1.88.4)."
				exit 1
			fi
			TAILSCALE_VERSION="$2"
			shift 2
			;;
		--help|-h)
			usage
			exit 0
			;;
		*)
			echo "Error: Unknown option: $1"
			usage
			exit 1
			;;
	esac
done

# 2. Validate options
if [[ "$TRACK" != "stable" && "$TRACK" != "unstable" ]]; then
	echo "Error: Unsupported track '$TRACK'. Use 'stable' or 'unstable'."
	exit 1
fi

# 3. Check if tailscale is already installed
if command -v tailscale &>/dev/null; then
	echo "==> tailscale already installed: $(tailscale version 2>/dev/null | head -n1 || echo 'version unknown'), skipping"
	exit 0
fi

# 4. Check if curl is available
if ! command -v curl &>/dev/null; then
	echo "Error: curl is not installed. Please install curl first and re-run this script."
	exit 1
fi

# 5. Install tailscale via official install script
echo "==> Installing tailscale (track: $TRACK${TAILSCALE_VERSION:+, version: $TAILSCALE_VERSION})..."

if [[ -n "$TAILSCALE_VERSION" ]]; then
	curl -fsSL https://tailscale.com/install.sh | env TRACK="$TRACK" TAILSCALE_VERSION="$TAILSCALE_VERSION" sh
else
	curl -fsSL https://tailscale.com/install.sh | env TRACK="$TRACK" sh
fi

# 6. Verify
if command -v tailscale &>/dev/null; then
	echo "==> tailscale installed successfully: $(tailscale version 2>/dev/null | head -n1 || echo 'version unknown')"
else
	echo "Error: tailscale installation failed (command not found)."
	exit 1
fi

echo "==> Next step: run 'sudo tailscale up' to authenticate this machine"
echo "==> Done!"
