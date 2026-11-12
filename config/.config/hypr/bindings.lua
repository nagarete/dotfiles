-- Personal keybinding overrides.
-- The Omarchy defaults already provide the standard app/webapp bindings
-- (Terminal, Browser, Editor, Music, web apps, ...), so only genuine overrides
-- and additions are listed here. Re-declaring a default binding would register
-- it twice and fire both.

-- Session management
o.bind("SUPER + SHIFT + Q", "Log out", hl.dsp.exit())

-- Overwrite the launcher on SUPER + SPACE with vicinae toggle
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Vicinae toggle", "vicinae toggle")
hl.unbind("SUPER + ALT+SPACE")
o.bind("SUPER + ALT + SPACE", "Omarchy menu", "omarchy-menu toggle")

-- Move focus with SUPER + vi-mode keys
hl.unbind("SUPER + K")
hl.unbind("SUPER + J")
hl.unbind("SUPER + L")
o.bind("SUPER + h", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + l", "Move focus right", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + k", "Move focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + j", "Move focus down", hl.dsp.focus({ direction = "d" }))

-- ALT replacements for the focus keys taken over by SUPER + vi-mode
o.bind("ALT + K", "Show key bindings", "omarchy-menu-keybindings")
o.bind("ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Swap active window with the one next to it using SUPER + SHIFT + vi-mode keys
o.bind("SUPER + SHIFT + h", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + l", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + k", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + j", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

-- Replace the default Omawrite binding on SUPER + SHIFT + W with Typora
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", { launch = "typora --enable-wayland-ime" })

-- Use Omasnap for capture and annotation.
-- PRINT was already bound to Screenshot by the Omarchy defaults.
hl.unbind("PRINT")
o.bind("PRINT", "Screenshot", "/usr/bin/omasnap")

-- Hex Linux shortcuts, delivered through the GlobalShortcuts portal.
-- On Hyprland 0.56, release Space before Alt in Hold mode.
-- Keep cancel unassigned so Escape remains available to applications.
o.bind("ALT + SPACE", "Hex dictation", hl.dsp.global("hex:dictation"))
o.bind("CTRL + ALT + V", "Hex paste last dictation", hl.dsp.global("hex:paste-last"))
o.bind("F9", "Hex Annotate", hl.dsp.global("hex:capture"))
