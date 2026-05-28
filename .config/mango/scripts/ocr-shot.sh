#!/bin/bash
# ~/.local/bin/ocr-shot

# Ensure tmp file is unique to avoid collisions
TEMP_IMG=$(mktemp /tmp/ocr_XXXXXX.png)

# Run the command chain
grim -g "$(slurp $SLURP_ARGS)" "$TEMP_IMG" && \
tesseract "$TEMP_IMG" - | wl-copy && \
rm "$TEMP_IMG"
