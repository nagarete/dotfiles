#!/bin/bash
# Apply host-specific Hyprland settings at startup

HOSTNAME=$(hostname)

if [ "$HOSTNAME" = "nagarete-len14" ]; then
    # Laptop: 14" high-DPI display needs 1.25x scaling
    hyprctl keyword monitor ",preferred,auto,1.25"

    # Touchpad preferences
    hyprctl keyword input:touchpad:natural_scroll true
    hyprctl keyword input:touchpad:scroll_factor 0.3
fi
