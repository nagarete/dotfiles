-- Extra autostart processes.
hl.on("hyprland.start", function()
  -- Setup host script
  hl.exec_cmd("~/.config/hypr/scripts/setup-host.sh")

  -- Vicinae clipboard sync server
  hl.exec_cmd("vicinae server")

  -- Browsers
  hl.exec_cmd("zen-browser")
  hl.exec_cmd([[google-chrome-stable --profile-directory="Default" --class="chrome-personal"]])
  hl.exec_cmd([[google-chrome-stable --profile-directory="Profile 1" --class="chrome-work"]])

  -- Discord client
  hl.exec_cmd("legcord")
end)
