#!/bin/bash

set +e

# something to do with scale value for xwayland apps
echo "Xft.dpi: 115" | xrdb -merge

waybar  >/dev/null 2>&1 &

swaync  >/dev/null 2>&1 &

systemctl --user start hyprpolkitagent.service >/dev/null 2>&1 &

sway-audio-idle-inhibit  >/dev/null 2>&1 &


# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &


hypridle >/dev/null 2>&1 & # screen idle management

sunsetr > /dev/null 2>&1 & # night light


# Start polkit agent
# trying hyprpolkitagent enabled via systemd user service
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &


# wallpaper slideshow fow swww
$HOME/.local/bin/wallpaper_slider $HOME/Pictures/wallpapers 1800 >/dev/null 2>&1 &
$HOME/.local/bin/battery_watcher-bin >/dev/null 2>&1 &

cliphist wipe
