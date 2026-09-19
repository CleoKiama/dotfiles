#!/usr/bin/env bash
# rofilaunch.sh — Rofi application launcher for MangoWM

r_mode="drun"

case "${1}" in
    d | --drun | "")
        r_mode="drun"
        ;;
    w | --window)
        r_mode="window"
        ;;
    f | --filebrowser)
        r_mode="filebrowser"
        ;;
    r | --run)
        r_mode="run"
        ;;
    h | --help)
        echo "Usage: $(basename "$0") [d|w|f|r]"
        exit 0
        ;;
    *)
        r_mode="drun"
        ;;
esac

# Toggle: close if already open
if pgrep -x rofi >/dev/null; then
    pkill -x rofi
    exit 0
fi

conf_dir="$HOME/.config/rofi"
theme_file="${conf_dir}/launcher.rasi"

exec rofi -show "${r_mode}" -theme "${theme_file}"
