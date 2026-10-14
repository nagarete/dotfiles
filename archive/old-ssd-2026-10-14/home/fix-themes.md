# Theme Fixes Tracking

## Overview
This file tracks the progress of fixing themes in `/home/nagarete/.config/omarchy/themes/` and `/home/nagarete/.local/share/omarchy/themes/`.

**Status**: ✅ All tasks completed

## Theme Locations
- **Custom themes**: `/home/nagarete/.config/omarchy/themes/`
- **Stock themes**: `/home/nagarete/.local/share/omarchy/themes/`

## Reference Theme Structure (from catppuccin)
A complete theme should have:
- `colors.toml` - Color definitions (accent, background, foreground, color0-15)
- `neovim.lua` - Neovim theme configuration
- `btop.theme` - Btop terminal monitor theme
- `icons.theme` - Icon theme name
- `vscode.json` - VS Code theme settings
- `preview.png` - Theme preview image
- `backgrounds/` - Wallpaper folder

---

## Summary of Changes

### 1. Artzen - ✅ Fixed
**Location**: `/home/nagarete/.config/omarchy/themes/artzen/`

**Actions Taken**:
- Created `colors.toml` with colors extracted from kitty.conf
- Created `vscode.json` with theme colors

---

### 2. Ash - ✅ Fixed
**Location**: `/home/nagarete/.config/omarchy/themes/ash/`

**Actions Taken**:
- Created `colors.toml` with gray/monotone color scheme

---

### 3. Dracula - ✅ Fixed
**Location**: `/home/nagarete/.config/omarchy/themes/dracula/`

**Actions Taken**:
- Created `colors.toml` with Dracula color palette
- Created `vscode.json` with theme colors
- Created `kitty.conf` with terminal colors

---

### 4. Frost - ✅ Fixed
**Location**: `/home/nagarete/.config/omarchy/themes/frost/`

**Actions Taken**:
- Created `colors.toml` with Frost blue-gray palette
- Created `vscode.json` with theme colors

---

### 5. Hackerman - ✅ Enhanced
**Location**: `/home/nagarete/.config/omarchy/themes/hackerman/`

**Actions Taken**:
- Enhanced `neovim.lua` with additional color variations:
  - Added `fg_light`, `fg_bright` for foreground variations
  - Added `green_light`, `green_bright`, `cyan_light`, `blue_light` for syntax variations
  - Added `add_light`, `change_light` for git colors
  - Added `off_white`, `gray`, `gray_light` for grayscale variations

---

### 6. Miasma - ✅ Enhanced
**Location**: `/home/nagarete/.config/omarchy/themes/miasma/`

**Actions Taken**:
- Enhanced `neovim.lua` with additional color variations:
  - Added `bg_darker`, `fg_light`, `fg_bright` for background/foreground variations
  - Added `border_light` for UI variations
  - Added `_light` variations for all syntax colors (red, orange, yellow, green, cyan, blue, purple, pink)
  - Added `brown`, `beige`, `olive` for swamp-themed extras

---

### 7. Red Monarch - ✅ Fixed
**Location**: `/home/nagarete/.config/omarchy/themes/red-monarch/`

**Actions Taken**:
- **Font Size Fix**: Removed explicit `font-size = 11` and `font-family` settings from `ghostty.conf` to match other themes
- **Color Enhancement**: Enhanced all color files with red variations instead of all colors being the same red:
  - Updated `colors.toml` with 16 unique colors (various shades of red)
  - Updated `kitty.conf` with color variations
  - Updated `alacritty.toml` with bright/normal color variations
  - Updated `ghostty.conf` with varied palette colors
  - Updated `neovim.lua` with additional color variations (`bright_red`, `dark_red`, `rose`, `salmon`)

---

### 8. Robzee84 - ✅ Fixed
**Location**: `/home/nagarete/.config/omarchy/themes/robzee84/`

**Actions Taken**:
- Created `vscode.json` with theme colors
- Fixed `colors.toml` to match the earthy brown/orange palette from neovim.lua (was incorrectly using synthwave colors)

---

### 9. Vantablack - ✅ Enhanced
**Location**: `/home/nagarete/.config/omarchy/themes/vantablack/`

**Actions Taken**:
- Enhanced `neovim.lua` with additional grayscale variations:
  - Added `bg_darker`, `fg_light`, `fg_muted` for base variations
  - Added `selection_light`, `comment_light`, `border_light` for UI variations
  - Added `_light` variations for all syntax colors
  - Added `gray`, `gray_light`, `gray_dark` for grayscale extras

---

### 10. White - ✅ Enhanced
**Location**: `/home/nagarete/.config/omarchy/themes/white/`

**Actions Taken**:
- Enhanced `neovim.lua` with additional grayscale variations:
  - Added `bg_darker`, `fg_light`, `fg_muted` for base variations
  - Added `selection_light`, `comment_light`, `border_light` for UI variations
  - Added `_light` variations for all syntax colors
  - Added `gray`, `gray_light`, `gray_dark` for grayscale extras

---

## Files Created/Modified

### New Files Created:
1. `/home/nagarete/.config/omarchy/themes/artzen/colors.toml`
2. `/home/nagarete/.config/omarchy/themes/artzen/vscode.json`
3. `/home/nagarete/.config/omarchy/themes/ash/colors.toml`
4. `/home/nagarete/.config/omarchy/themes/dracula/colors.toml`
5. `/home/nagarete/.config/omarchy/themes/dracula/vscode.json`
6. `/home/nagarete/.config/omarchy/themes/dracula/kitty.conf`
7. `/home/nagarete/.config/omarchy/themes/frost/colors.toml`
8. `/home/nagarete/.config/omarchy/themes/frost/vscode.json`
9. `/home/nagarete/.config/omarchy/themes/robzee84/vscode.json`

### Files Modified:
1. `/home/nagarete/.config/omarchy/themes/hackerman/neovim.lua` - Added color variations
2. `/home/nagarete/.config/omarchy/themes/miasma/neovim.lua` - Added color variations
3. `/home/nagarete/.config/omarchy/themes/red-monarch/colors.toml` - Added color variations
4. `/home/nagarete/.config/omarchy/themes/red-monarch/kitty.conf` - Added color variations, removed font settings
5. `/home/nagarete/.config/omarchy/themes/red-monarch/alacritty.toml` - Added color variations
6. `/home/nagarete/.config/omarchy/themes/red-monarch/ghostty.conf` - Added color variations, removed font settings
7. `/home/nagarete/.config/omarchy/themes/red-monarch/neovim.lua` - Added color variations
8. `/home/nagarete/.config/omarchy/themes/robzee84/colors.toml` - Fixed to match theme palette
9. `/home/nagarete/.config/omarchy/themes/vantablack/neovim.lua` - Added color variations
10. `/home/nagarete/.config/omarchy/themes/white/neovim.lua` - Added color variations

---

## Verification

To verify the fixes work:
1. Run `omarchy-theme-list` to see available themes
2. Apply a theme: `omarchy-theme-set "Theme Name"` (e.g., `omarchy-theme-set artzen`)
3. Check that colors apply correctly across applications
4. For neovim colors, open nvim and verify the colorscheme loads
