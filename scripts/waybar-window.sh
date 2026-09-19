#!/usr/bin/env bash
# waybar-window.sh — Stream focused window title from MangoWM to Waybar

while true; do
    mmsg watch focusing-client 2>/dev/null | jq --unbuffered -c '
        if .error or (. | type != "object") or (.title == null) or (.title == "") then
            {"text": "", "alt": "", "tooltip": "", "class": "empty"}
        else
            {"text": .title, "tooltip": (.appid // ""), "class": (.appid // "")}
        end'
    sleep 1
done
