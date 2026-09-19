#!/usr/bin/env bash

# Toggle behavior: if wlogout is already running, close it
if pgrep -x "wlogout" >/dev/null 2>&1; then
    pkill -x "wlogout"
    exit 0
fi

# Launch wlogout with 5 columns, centered margins, and layer-shell protocol
wlogout -b 5 -c 16 -r 16 -T 370 -B 370 -L 360 -R 360 --protocol layer-shell
