#!/bin/bash

set +e

# something to do with scale value for xwayland apps
echo "Xft.dpi: 115" | xrdb -merge

# Claim the PAM-unlocked keyring before it times out / before D-Bus activation spawns a fresh one
gnome-keyring-daemon --start --components=secrets,ssh,pkcs11 >/dev/null 2>&1
export $(gnome-keyring-daemon --start --components=secrets,ssh,pkcs11 2>/dev/null)

waybar  >/dev/null 2>&1 &

swaync  >/dev/null 2>&1 &




# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &


hypridle >/dev/null 2>&1 & # screen idle management

sunsetr > /dev/null 2>&1 & # night light


$HOME/.config/mango/scripts/ai-router.sh >/dev/null 2>&1 &

# Start polkit agent
# trying hyprpolkitagent enabled via systemd user service
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &


# wallpaper slideshow fow swww
$HOME/.local/bin/wallpaper_slider $HOME/Pictures/wallpapers 1800 >/dev/null 2>&1 &
$HOME/.local/bin/battery_watcher-bin >/dev/null 2>&1 &

cliphist wipe

sway-audio-idle-inhibit  >/dev/null 2>&1 &

systemctl --user start hyprpolkitagent.service >/dev/null 2>&1 &
# sleep 3 &
# systemctl --user start emacs.service >/dev/null 2>&1 &

