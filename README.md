# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start (New System)

```bash
# 1. Clone and run install script
cd ~
git clone git@github.com:nagarete/dotfiles.git
cd dotfiles
./install.sh
```

The install script will:
- Backup existing configs to `~/dotfiles_backup/`
- Remove conflicting configs
- Create symlinks with stow
- Validate Hyprland config

**Or manually:**
```bash
cd ~/dotfiles
stow */
```

## How to Update Configs

### Method 1: Edit via Symlinks (Easiest)

Edit directly in `~/.config` or `~` - changes apply instantly:

```bash
# Editing this file...
nvim ~/.config/hypr/hyprland.conf

# ...actually edits this file (via symlink):
# ~/dotfiles/config/.config/hypr/hyprland.conf

# Just commit and push when done
cd ~/dotfiles
git add .
git commit -m "Update hyprland config"
git push
```

### Method 2: Edit in Dotfiles Directory

```bash
# Edit the source file
cd ~/dotfiles
nvim config/.config/hypr/hyprland.conf

# Commit and push
git add config/.config/hypr/hyprland.conf
git commit -m "Update hyprland config"
git push

# Changes apply immediately (symlink is live)
```

## How to Add New Configs

```bash
cd ~/dotfiles

# 1. Create the directory structure
mkdir -p config/.config/newapp

# 2. Copy your config
cp ~/.config/newapp/config.toml config/.config/newapp/

# 3. Remove original and stow
rm -rf ~/.config/newapp
stow config

# 4. Verify symlink
ls -la ~/.config/newapp

# 5. Commit to git
git add config/.config/newapp
git commit -m "Add newapp config"
git push
```

## Stow Commands Reference

```bash
cd ~/dotfiles

# Stow all packages
stow */

# Stow specific package
stow zsh
stow config

# Unstow (remove symlinks)
stow -D zsh

# Restow (relink, useful after adding new files)
stow -R config

# Dry run (see what would happen without doing it)
stow -n -v */
```

## Structure

```
~/dotfiles/
├── bash/          → ~/.bashrc, ~/.bash_profile, ~/.bash_logout
├── zsh/           → ~/.zshrc
├── starship/      → ~/.config/starship.toml
├── config/        → ~/.config/ contents
│   └── .config/
│       ├── hypr/
│       ├── waybar/
│       ├── kitty/
│       ├── nvim/
│       ├── tmux/
│       ├── zellij/
│       ├── opencode/
│       └── ...
├── agents/        → ~/.agents/ contents (user skills)
│   └── .agents/
│       └── skills/
└── nvim/          → ~/.config/nvim (separate package)
```

Each directory represents a "package" that can be stowed independently.

## Important Notes

- **Symlinks are live**: Editing `~/.config/file` edits `~/dotfiles/config/.config/file`
- **New files**: If you create new files in `~/.config/`, they won't be symlinks. Move them to `~/dotfiles` and run `stow -R`.
- **Backup**: Always backup before setting up on a new system
- **Git submodules**: Avoid using git submodules inside dotfiles - they cause issues with stow

## Omarchy Notes

These dotfiles are designed for [Omarchy](https://omarchy.org/) (Arch Linux + Hyprland).

### Hyprland Config Layers

Configs load in this order (later overrides earlier):
1. System defaults (`~/.local/share/omarchy/default/hypr/`)
2. Theme configs (`~/.config/omarchy/current/theme/`)
3. **Your configs** (`~/.config/hypr/`)

### Keybinding Rules

When overriding defaults, use `unbind` first:

```conf
unbind = SUPER, SPACE
bind = SUPER, SPACE, exec, my-app
```

Check existing bindings:
```bash
omarchy-menu-keybindings --print | grep "SUPER + SPACE"
```

### Validate Config

```bash
hyprctl reload      # Should print "ok"
hyprctl binds       # List all bindings
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Changes not applying | `stow -R */` |
| Broken symlink | `rm ~/.config/broken && stow config` |
| See what stow will do | `stow -n -v */` |
| Keybindings not working | `hyprctl reload` should print "ok" |
| Check bindings | `omarchy-menu-keybindings --print` |

**Forgot to unbind?**
```conf
unbind = SUPER, KEY
bind = SUPER, KEY, action
```
