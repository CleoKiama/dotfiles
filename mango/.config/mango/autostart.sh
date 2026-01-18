#!/bin/bash

set +e 
# screen share staff
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1

waybar  >/dev/null 2>&1 &

swww-daemon >/dev/null 2>&1 &

swaync  >/dev/null 2>&1 &


# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &


hypridle >/dev/null 2>&1 &


# Start polkit agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &
 
# wallpaper slideshow fow swww
$HOME/dotfiles/scripts/wallpaper_slideshow.sh $HOME/Pictures/wallpapers 1800 >/dev/null 2>&1 &
$HOME/.local/bin/battery-watcher.sh >/dev/null 2>&1 &

cliphist wipe
