-- Extra autostart processes (ported from autostart.conf).
o.exec_on_start("~/.config/hypr/scripts/setup-host.sh")
o.launch_on_start("vicinae server")
-- o.launch_on_start("zen-browser")
-- o.launch_on_start('google-chrome-stable --profile-directory="Default" --class="chrome-personal"') -- myself
-- o.launch_on_start('google-chrome-stable --profile-directory="Profile 1" --class="chrome-work"')   -- Aurum
o.launch_on_start('helium-browser --profile-directory="Default" --window-name="helium-home"') -- home
o.launch_on_start('helium-browser --profile-directory="Profile 2" --window-name="helium-aurum"') -- Aurum Squared
o.launch_on_start('helium-browser --profile-directory="Profile 3" --window-name="helium-gallant"') -- Gallant AI
o.launch_on_start("legcord")
o.launch_on_start("~/.local/bin/t3-code")
