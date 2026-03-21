# Dotfiles

Managed with GNU Stow.

## Installation

```bash
# Install stow
sudo pacman -S stow

# Stow all packages
stow */

# Or stow specific packages
stow zsh
stow config
```

## Structure

Each directory represents a "package" that can be stowed independently:
- `zsh/` - Zsh shell configuration
- `bash/` - Bash shell configuration  
- `config/` - ~/.config/ contents
- `nvim/` - Neovim configuration
- `starship/` - Starship prompt configuration

## How Stow Works

Stow creates symlinks from the dotfiles directory to your home directory.
For example, `zsh/.zshrc` gets symlinked to `~/.zshrc`.

## Adding New Configs

1. Create the directory structure in the appropriate package
2. Copy your config files there
3. Run `stow <package-name>`

# dotfiles
