-- Window placement rules (ported from windows.conf).
o.window("(zen)", { workspace = "1" })
o.window("(chrome-work)", { workspace = "2" })
o.window("(chrome-personal)", { workspace = "2" })
o.window("(legcord)", { workspace = "3" })
o.window("^com\\.t3tools\\.T3Code$", { workspace = "4" })

-- Chrome's Wayland notification popups have no app ID or title.
-- Keep unnamed native popups out of the tiling layout and preserve app focus.
o.window({
  class = "^$",
  title = "^$",
  xwayland = false,
  fullscreen = false,
  pin = false,
}, {
  name = "float-unnamed-wayland-popups",
  float = true,
  no_initial_focus = true,
  no_follow_mouse = true,
  move = { "monitor_w-window_w-12", "38" },
  decorate = false,
  no_blur = true,
  no_shadow = true,
})
