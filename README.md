# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What Went Wrong Last Time

**Problem:** Keybindings stopped working after cloning dotfiles to a new system.

**Root Cause:** Syntax errors in `~/.config/hypr/bindings.conf`:

```conf
# WRONG - all lines use 'h' key instead of h/j/k/l:
bindd = SUPER SHIFT, h, Swap window to the left, swapwindow,l
bindd = SUPER SHIFT, l, Swap window to the right, swapwindow,l
bindd = SUPER SHIFT, h, Swap window to the up, swapwindow,u     # Wrong key!
bindd = SUPER SHIFT, h, Swap window to the down, swapwindow,d   # Wrong key!

# FIXED:
bindd = SUPER SHIFT, h, Swap window to the left, swapwindow, l
bindd = SUPER SHIFT, l, Swap window to the right, swapwindow, r
bindd = SUPER SHIFT, k, Swap window to the up, swapwindow, u
bindd = SUPER SHIFT, j, Swap window to the down, swapwindow, d
```

**Lesson:** Always validate configs with `hyprctl reload` before committing.

---

## Quick Start (New System)

```bash
# 1. Install stow
sudo pacman -S stow

# 2. Clone your dotfiles
cd ~
git clone git@github.com:nagarete/dotfiles.git

# 3. Backup existing configs (optional but recommended)
mkdir -p ~/dotfiles_backup
cp ~/.zshrc ~/dotfiles_backup/ 2>/dev/null
cp ~/.bashrc ~/dotfiles_backup/ 2>/dev/null
cp -r ~/.config/hypr ~/dotfiles_backup/ 2>/dev/null

# 4. Remove existing configs that conflict with dotfiles
rm -f ~/.zshrc ~/.bashrc ~/.bash_profile ~/.bash_logout
rm -f ~/.config/starship.toml
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/nvim \
       ~/.config/tmux ~/.config/zellij ~/.config/walker ~/.config/mako \
       ~/.config/btop ~/.config/alacritty ~/.config/ghostty ~/.config/micro \
       ~/.config/fastfetch

# 5. Stow all packages (creates symlinks)
cd ~/dotfiles
stow */

# 6. Verify symlinks are working
ls -la ~ | grep dotfiles
ls -la ~/.config/ | grep dotfiles
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
│       └── ...
└── nvim/          → ~/.config/nvim (separate package)
```

Each directory represents a "package" that can be stowed independently.

## Important Notes

- **Symlinks are live**: Editing `~/.config/file` edits `~/dotfiles/config/.config/file`
- **New files**: If you create new files in `~/.config/`, they won't be symlinks. Move them to `~/dotfiles` and run `stow -R`.
- **Backup**: Always backup before setting up on a new system
- **Git submodules**: Avoid using git submodules inside dotfiles - they cause issues with stow

## Omarchy-Specific Notes

These dotfiles are designed for [Omarchy](https://omarchy.org/) - an Arch Linux distribution with Hyprland.

### How Hyprland Config Works in Omarchy

Omarchy uses a layered config system:

1. **System defaults** (`~/.local/share/omarchy/default/hypr/`) - DON'T EDIT THESE
2. **Theme configs** (`~/.config/omarchy/current/theme/`) - Theme-specific settings
3. **User configs** (`~/.config/hypr/`) - YOUR CUSTOMIZATIONS GO HERE

The main `hyprland.conf` sources files in this order:
- First: Omarchy defaults (bindings, media keys, env vars, etc.)
- Last: Your user configs (can override anything)

### Keybinding Overrides

When overriding Omarchy's default keybindings, you MUST use `unbind` first:

```conf
# WRONG - will cause conflicts:
bind = SUPER, SPACE, exec, my-app

# CORRECT - unbind first, then bind:
unbind = SUPER, SPACE
bind = SUPER, SPACE, exec, my-app
```

Check existing bindings before overriding:
```bash
omarchy-menu-keybindings --print | grep "SUPER + SPACE"
```

### Validating Hyprland Config

Always validate before committing:

```bash
# Check for syntax errors
hyprctl reload

# If you see "ok", config is valid
# If you see errors, fix them before committing

# List all active bindings
hyprctl binds

# Check specific binding
hyprctl binds | grep -A5 "key: h"
```

Common syntax errors to avoid:
- Typos in key names (`SUPER SHIFT, h` vs `SUPER SHIFT, j`)
- Missing commas or wrong argument order
- Duplicate keybindings without `unbind`

## Troubleshooting

### Config changes not applying?
```bash
stow -R */  # Restow everything
```

### Symlink broken?
```bash
# Remove broken link and restow
rm ~/.config/broken-link
stow config
```

### Want to see what stow will do?
```bash
stow -n -v */  # Dry run with verbose output
```

### Keybindings not working?

1. **Check if Hyprland loaded your config:**
   ```bash
   hyprctl reload
   # Should print "ok"
   ```

2. **Verify bindings are loaded:**
   ```bash
   omarchy-menu-keybindings --print
   ```

3. **Check for conflicts:**
   ```bash
   hyprctl binds | grep "key: SPACE"
   # Look for duplicate bindings
   ```

4. **Common issue - forgot to unbind:**
   If overriding a default Omarchy binding, you need:
   ```conf
   unbind = SUPER, KEY
   bind = SUPER, KEY, action
   ```

5. **Syntax error in bindings.conf:**
   Check line-by-line for typos, especially:
   - Wrong keys (`h` instead of `j`)
   - Missing spaces after commas
   - Wrong argument order
