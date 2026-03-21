#!/bin/bash
# Dotfiles installation script

set -e

echo "Installing dotfiles with GNU Stow..."

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed."
    echo "Install it with: sudo pacman -S stow"
    exit 1
fi

# Stow all packages
echo "Stowing packages..."
stow -v */

echo "Dotfiles installed successfully!"
echo ""
echo "Active symlinks:"
stow -v */ 2>&1 | grep -E "(LINK|UNLINK)" || echo "All packages stowed."

