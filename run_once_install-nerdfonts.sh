#!/bin/bash
# Installs Nerd Fonts (runs once on first chezmoi apply)

set -euo pipefail

FONT_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONT_DIR}"

echo "Installing Nerd Fonts..."

# VictorMono Nerd Font
if ! fc-list | grep -qi "VictorMono Nerd Font"; then
    echo "Downloading VictorMono Nerd Font..."
    curl -fsSL -o /tmp/VictorMono.tar.xz \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/VictorMono.tar.xz"
    tar -xf /tmp/VictorMono.tar.xz -C "${FONT_DIR}"
    rm /tmp/VictorMono.tar.xz
    echo "VictorMono Nerd Font installed."
else
    echo "VictorMono Nerd Font already installed."
fi

# Rebuild font cache
fc-cache -f

echo "Nerd Fonts installation complete!"
