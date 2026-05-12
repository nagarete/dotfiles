-- Application bindings.
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"]]), { description = "Terminal" })
hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"]]), { description = "Tmux" })
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("uwsm-app -- nautilus --new-window"), { description = "File manager" })
hl.bind("SUPER + ALT + SHIFT + F", hl.dsp.exec_cmd([[uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"]]), { description = "File manager (cwd)" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd("omarchy-launch-browser --private"), { description = "Browser (private)" })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus spotify"), { description = "Music" })
hl.bind("SUPER + SHIFT + ALT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus-tui cliamp"), { description = "Music TUI" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("omarchy-launch-editor"), { description = "Editor" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("omarchy-launch-tui lazydocker"), { description = "Docker" })
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"]]), { description = "Signal" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd([[omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"]]), { description = "Obsidian" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("uwsm-app -- typora --enable-wayland-ime"), { description = "Typora" })
hl.bind("SUPER + SHIFT + SLASH", hl.dsp.exec_cmd("uwsm-app -- 1password"), { description = "Passwords" })

-- Web app bindings.
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://chatgpt.com"]]), { description = "ChatGPT" })
hl.bind("SUPER + SHIFT + ALT + A", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://grok.com"]]), { description = "Grok" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"]]), { description = "Calendar" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://app.hey.com"]]), { description = "Email" })
hl.bind("SUPER + SHIFT + Y", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://youtube.com/"]]), { description = "YouTube" })
hl.bind("SUPER + SHIFT + ALT + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"]]), { description = "WhatsApp" })
hl.bind("SUPER + SHIFT + CTRL + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus-webapp "Google Messages" "https://messages.google.com/web/conversations"]]), { description = "Google Messages" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd([[omarchy-launch-or-focus-webapp "Google Photos" "https://photos.google.com/"]]), { description = "Google Photos" })
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://x.com/"]]), { description = "X" })
hl.bind("SUPER + SHIFT + ALT + X", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://x.com/compose/post"]]), { description = "X Post" })

-- Move focus with SUPER + vi mode (overrides default SUPER+J/K/L bindings).
hl.unbind("SUPER + K")
hl.unbind("SUPER + J")
hl.unbind("SUPER + L")
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }), { description = "Move focus left" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }), { description = "Move focus right" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }), { description = "Move focus up" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }), { description = "Move focus down" })

-- Replacement bindings on ALT for the displaced defaults.
hl.bind("ALT + K", hl.dsp.exec_cmd("omarchy-menu-keybindings"), { description = "Show key bindings" })
hl.bind("ALT + J", hl.dsp.layout("togglesplit"), { description = "Toggle window split" })
hl.bind("ALT + L", hl.dsp.exec_cmd("omarchy-hyprland-workspace-layout-toggle"), { description = "Toggle workspace layout" })

-- Swap active window with SUPER + SHIFT + vi mode.
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window to the left" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window to the right" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

-- Session management.
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("exit"), { description = "Log out" })

-- Overwrite existing bindings with hl.unbind() first if needed.
hl.unbind("SUPER + SPACE")
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("vicinae toggle"), { description = "Vicinae clipboard" })
-- hl.bind("SUPER + CTRL + ALT + SHIFT + SPACE", hl.dsp.exec_cmd("vicinae toggle"), { description = "Vicinae clipboard (fallback)" })

-- Logitech MX Keys examples:
-- hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("omarchy-capture-screenshot"))
-- hl.bind("SUPER + H", hl.dsp.exec_cmd("voxtype record toggle"))
-- hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("omarchy-launch-walker -m symbols"))
