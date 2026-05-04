#!/bin/bash
# Installs atuin via the official setup script (run once).

set -euo pipefail

if command -v atuin >/dev/null 2>&1; then
    echo "atuin already installed; skipping."
    exit 0
fi

echo "Installing atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
echo "atuin installed."
