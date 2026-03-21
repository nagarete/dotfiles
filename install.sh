#!/bin/bash
set -e

echo "🔧 Installing dotfiles..."

if ! command -v stow &> /dev/null; then
    echo "❌ Error: GNU Stow not installed. Run: sudo pacman -S stow"
    exit 1
fi

mkdir -p ~/dotfiles_backup
cp ~/.zshrc ~/dotfiles_backup/ 2>/dev/null || true
cp ~/.bashrc ~/dotfiles_backup/ 2>/dev/null || true
cp -r ~/.config/hypr ~/dotfiles_backup/ 2>/dev/null || true

rm -f ~/.zshrc ~/.bashrc ~/.bash_profile ~/.bash_logout
rm -f ~/.config/starship.toml
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/nvim \
       ~/.config/tmux ~/.config/zellij ~/.config/walker ~/.config/mako \
       ~/.config/btop ~/.config/alacritty ~/.config/ghostty ~/.config/micro \
       ~/.config/fastfetch ~/.config/lazydocker ~/.config/lazygit

stow */

echo ""
echo "✅ Dotfiles installed!"

if command -v hyprctl &> /dev/null; then
    echo ""
    echo "🔍 Validating Hyprland config..."
    if hyprctl reload &>/dev/null; then
        echo "✅ Hyprland config valid"
    else
        echo "⚠️  Warning: Hyprland config has errors - run 'hyprctl reload' for details"
    fi
fi
