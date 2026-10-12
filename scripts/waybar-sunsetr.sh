#!/usr/bin/env bash
# waybar-sunsetr.sh — Stream Sunsetr status to Waybar

while true; do
    if ! pgrep -x sunsetr >/dev/null 2>&1; then
        echo '{"text":"","alt":"off","tooltip":"Sunsetr is not running","class":"off"}'
        sleep 2
        continue
    fi

    sunsetr status --json --follow 2>/dev/null | jq --unbuffered -c '
        if .event_type == "preset_changed" then
            {
                text: "\(.target_temp)K",
                alt: .target_period,
                tooltip: "Preset: \(.to_preset // "default")\nTarget: \(.target_temp)K @ \(.target_gamma)%",
                class: .target_period
            }
        elif .event_type == "config_changed" then
            {
                text: "\(.target_temp)K",
                alt: .target_period,
                tooltip: "Config changed\nTarget: \(.target_temp)K @ \(.target_gamma)%",
                class: .target_period
            }
        elif .event_type == "state_applied" then
            {
                text: "\(.current_temp)K",
                alt: .period,
                tooltip: "Period: \(.period)\nTemp: \(.current_temp)K @ \(.current_gamma)%",
                class: .period
            }
        else
            empty
        end'
    sleep 1
done
