#!/bin/bash

uid=$(id -u)
rt=/run/user/$uid
scan=$rt/service
live=$rt/s6-rc

# session bus: only start if nothing answers on the socket
if ! busctl --address="unix:path=$rt/bus" status >/dev/null 2>&1; then
    rm -f "$rt/bus"
    dbus-daemon --session --address="unix:path=$rt/bus" \
        --fork --nopidfile --syslog-only
fi
export DBUS_SESSION_BUS_ADDRESS="unix:path=$rt/bus"
# dbus-update-activation-environment --all

# user s6 tree: s6-svscanctl succeeds only if a svscan is listening
if ! s6-svscanctl "$scan" 2>/dev/null; then
    rm -rf "$scan" "$live"            # stale state from a dead tree
    mkdir -p "$scan"
    setsid -f s6-svscan "$scan"
    until s6-svscanctl "$scan" 2>/dev/null; do sleep 0.1; done
    s6-rc-init -c "$HOME/.local/share/s6/rc/compiled" -l "$live" "$scan"
fi

s6-rc -l "$live" -up change default   # no-op for services already up


# Text scaling factor for GTK/Wayland applications
gsettings set org.gnome.desktop.interface text-scaling-factor 1.15

# Claim the PAM-unlocked keyring before it times out / before D-Bus activation spawns a fresh one
gnome-keyring-daemon --start --components=secrets,ssh,pkcs11 >/dev/null 2>&1
export $(gnome-keyring-daemon --start --components=secrets,ssh,pkcs11 2>/dev/null)

waybar  >/dev/null 2>&1 &

swaync  >/dev/null 2>&1 &

# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &
wl-paste --type image --watch cliphist store >/dev/null 2>&1 &


hypridle >/dev/null 2>&1 & # screen idle management

sunsetr > /dev/null 2>&1 & # night light

blueman-applet > /dev/null 2>&1 & # bluetooth

connman-gtk --tray > /dev/null 2>&1 & # network tray


$HOME/.config/mango/scripts/ai-router.sh >/dev/null 2>&1 &

# Start polkit agent
# trying hyprpolkitagent enabled via systemd user service
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &


# wallpaper slideshow fow swww
$HOME/.local/bin/wallpaper_slider $HOME/Pictures/wallpapers 1800 >/dev/null 2>&1 &
$HOME/.local/bin/battery-watcher.sh >/dev/null 2>&1 &

cliphist wipe

# sway-audio-idle-inhibit  >/dev/null 2>&1 &

# sleep 3 &
# systemctl --user start emacs.service >/dev/null 2>&1 &

