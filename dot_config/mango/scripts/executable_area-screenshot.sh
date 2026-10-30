#!/usr/bin/env bash

# Select region or window
GEOM=$(slurp $SLURP_ARGS) || exit 0

TMP_IMG="/tmp/screenshot-annotated.png"
rm -f "$TMP_IMG"

# Launch Satty for annotations, then copy result to clipboard
grim -g "$GEOM" - | satty -f - -o "$TMP_IMG"

if [ -f "$TMP_IMG" ]; then
    wl-copy < "$TMP_IMG"
    notify-send "Screenshot Captured" "Annotated image copied to clipboard" -i camera-photo
fi
