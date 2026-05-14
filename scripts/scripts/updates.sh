#!/bin/bash
#  _   _           _       _
# | | | |_ __   __| | __ _| |_ ___  ___  | | | | '_ \ / _` |/ _` | __/ _ \/ __|
# | |_| | |_) | (_| | (_| | ||  __/\__ \
    #  \___/| .__/ \__,_|\__,_|\__\___||___/
#       |_|
#
# by Stephan Raabe (2023)
# -----------------------------------------------------
# Requires pacman-contrib yay flatpak

# -----------------------------------------------------
# Check for debug mode
# -----------------------------------------------------
DEBUG=${1:-false}

debug_log() {
    if [ "$DEBUG" = "--debug" ]; then
        echo "[DEBUG] $1" >&2
    fi
}

# -----------------------------------------------------
# Define threshholds for color indicators
# -----------------------------------------------------

threshhold_green=0
threshhold_yellow=25
threshhold_red=100

# -----------------------------------------------------
# Calculate available updates pacman, aur, and flatpak
# -----------------------------------------------------

debug_log "Checking pacman updates..."
if ! updates_arch=$(yay -Qu --repo --quiet 2> /dev/null | wc -l); then
    updates_arch=0
    debug_log "yay repo check failed, setting pacman updates to 0"
else
    debug_log "Found $updates_arch pacman updates"
fi

debug_log "Checking AUR updates..."
if ! updates_aur=$(yay -Qu --aur --quiet 2> /dev/null | wc -l); then
    updates_aur=0
    debug_log "yay failed, setting AUR updates to 0"
else
    debug_log "Found $updates_aur AUR updates"
fi

debug_log "Checking Flatpak updates..."
if ! updates_flatpak=$(flatpak remote-ls --updates 2> /dev/null | wc -l); then
    updates_flatpak=0
    debug_log "flatpak failed, setting Flatpak updates to 0"
else
    debug_log "Found $updates_flatpak Flatpak updates"
fi

updates=$(("$updates_arch" + "$updates_aur" + "$updates_flatpak"))
debug_log "Total updates: $updates (pacman: $updates_arch, AUR: $updates_aur, flatpak: $updates_flatpak)"

# -----------------------------------------------------
# Output in JSON format for Waybar Module custom-updates
# -----------------------------------------------------

css_class="green"

if [ "$updates" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$updates" -gt $threshhold_red ]; then
    css_class="red"
fi

if [ "$updates" -gt $threshhold_green ]; then
    printf '{"text": "%s", "alt": "%s", "tooltip": "Click to update your system", "class": "%s"}' "$updates" "$updates" "$css_class"
else
    printf '{"text": "0", "alt": "0", "tooltip": "No updates available", "class": "green"}'
fi
