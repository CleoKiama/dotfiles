#!/usr/bin/env bash

# Select region or window
GEOM=$(slurp $SLURP_ARGS) || exit 0

TEMP_IMG=$(mktemp /tmp/ocr_XXXXXX.png)

grim -g "$GEOM" "$TEMP_IMG" && \
    tesseract "$TEMP_IMG" - | wl-copy && \
    notify-send -a "OCR" "Text extracted to clipboard" -i edit-copy

rm -f "$TEMP_IMG"
