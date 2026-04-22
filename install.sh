#!/bin/bash
set -e

echo "🔧 Installing dotfiles..."

if ! command -v stow &> /dev/null; then
    echo "❌ Error: GNU Stow not installed. Run: sudo pacman -S stow"
    exit 1
fi

install_zsh() {
    if ! command -v zsh &> /dev/null; then
        echo "📦 Installing zsh..."
        sudo pacman -S --needed zsh
    fi

    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "🐚 Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        echo "✅ zsh set as default shell (will take effect on next login)"
    fi
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "📦 Installing Oh My Zsh..."
        if ! command -v curl &> /dev/null; then
            echo "❌ Error: curl not installed. Run: sudo pacman -S curl"
            exit 1
        fi
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        echo "✅ Oh My Zsh installed"
    fi
}

install_ghostty() {
    if ! command -v ghostty &> /dev/null; then
        echo "📦 Installing ghostty..."
        sudo pacman -S --needed ghostty
    fi

    if command -v xdg-mime &> /dev/null; then
        CURRENT_TERMINAL=$(xdg-mime query default x-scheme-handler/terminal 2>/dev/null || echo "")
        if [ "$CURRENT_TERMINAL" != "com.mitchellh.ghostty.desktop" ]; then
            echo "🖥️  Setting ghostty as default terminal..."
            xdg-mime default com.mitchellh.ghostty.desktop x-scheme-handler/terminal
            echo "✅ ghostty set as default terminal"
        fi
    fi
}

backup_existing_configs() {
    mkdir -p ~/dotfiles_backup
    cp ~/.zshrc ~/dotfiles_backup/ 2>/dev/null || true
    cp ~/.bashrc ~/dotfiles_backup/ 2>/dev/null || true
    cp -r ~/.config/hypr ~/dotfiles_backup/ 2>/dev/null || true
}

cleanup_existing_configs() {
    rm -f ~/.zshrc ~/.bashrc ~/.bash_profile ~/.bash_logout
    rm -f ~/.config/starship.toml
    rm -rf ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/nvim \
           ~/.config/tmux ~/.config/zellij ~/.config/walker ~/.config/mako \
           ~/.config/btop ~/.config/alacritty ~/.config/ghostty ~/.config/micro \
           ~/.config/fastfetch ~/.config/lazydocker ~/.config/lazygit \
           ~/.config/opencode ~/.agents/skills
}

validate_hyprland() {
    if command -v hyprctl &> /dev/null; then
        echo ""
        echo "🔍 Validating Hyprland config..."
        if hyprctl reload &>/dev/null; then
            echo "✅ Hyprland config valid"
        else
            echo "⚠️  Warning: Hyprland config has errors - run 'hyprctl reload' for details"
        fi
    fi
}

install_zsh
install_oh_my_zsh
install_ghostty
backup_existing_configs
cleanup_existing_configs

stow */

echo ""
echo "✅ Dotfiles installed!"

validate_hyprland
