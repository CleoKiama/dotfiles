#!/usr/bin/env bash

# Path to your Catppuccin Rofi theme
THEME="$HOME/dotfiles/scripts/rofiTheme/theme.rasinc"

rofimoji \
    --action copy \
    --clipboarder wl-copy \
    --selector-args "-theme $THEME"
