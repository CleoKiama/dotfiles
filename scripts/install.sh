#!/usr/bin/env bash

# --- 1. GHOSTTY WRAPPER ---
# This block detects if the script is running inside Ghostty.
# If not, it re-opens itself inside a new Ghostty window with the correct flags.
if [ "$GHOSTTY_UPDATING" != "true" ]; then
    # Check if Ghostty is installed
    if ! command -v ghostty >/dev/null 2>&1; then
        notify-send "System Update" "Ghostty terminal is not installed." -u critical
        exit 1
    fi

    # Launch this same script ($0) inside Ghostty
    # --title: Sets the window title
    # --wait-after-command: Keeps the window open after completion
    # -e: Tells Ghostty the following is a command, not a config setting
    GHOSTTY_UPDATING=true ghostty --title="System Update" --wait-after-command=true -e bash "$0"
    exit 0
fi

# --- 2. UPDATE LOGIC (RUNS INSIDE GHOSTTY) ---
set -e  # Exit on any error

# Handle cleanup and notifications on error
error_handler() {
    local exit_code=$?
    notify-send "System Update" "An error occurred (code: $exit_code)" -u critical
    echo "❌ Error occurred! Exit code: $exit_code"
    # Kill the sudo keep-alive process if it exists
    [[ -n "$SUDO_LOOP_PID" ]] && kill "$SUDO_LOOP_PID" 2>/dev/null || true
    exit $exit_code
}

trap error_handler ERR

echo "🔐 Authenticating with sudo for system updates..."
if ! sudo -v; then
    echo "❌ Failed to authenticate sudo. Exiting."
    exit 1
fi

# Keep sudo timestamp alive in the background
( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) &
SUDO_LOOP_PID=$!
trap 'kill "$SUDO_LOOP_PID" 2>/dev/null || true' EXIT

notify-send "System Update" "Updates starting now..." -u normal

# --- 3. SYSTEM INFO & REPO UPDATES ---
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
elif command -v neofetch >/dev/null 2>&1; then
    neofetch
fi

echo "📦 Performing full system update (pacman -Syu)..."
sudo pacman -Syu --noconfirm

# --- 4. AUR UPDATES ---
if command -v yay >/dev/null 2>&1; then
    echo "📦 Updating AUR packages (yay)..."
    yay -Syu --noconfirm
elif command -v paru >/dev/null 2>&1; then
    echo "📦 Updating AUR packages (paru)..."
    paru -Syu --noconfirm
fi

# --- 5. FLATPAK UPDATES ---
if command -v flatpak >/dev/null 2>&1; then
    echo "📦 Updating Flatpak packages..."
    flatpak update -y
fi

# --- 6. CLEANUP TASKS ---
echo ""
read -p "🧹 Would you like to clean package caches? [y/N] " -r clean_cache
if [[ "$clean_cache" =~ ^[Yy]$ ]]; then
    sudo pacman -Sc --noconfirm
    command -v yay >/dev/null && yay -Sc --noconfirm
    command -v paru >/dev/null && paru -Sc --noconfirm
fi

echo "🔍 Checking for orphaned packages..."
orphans=$(pacman -Qtdq)
if [ -n "$orphans" ]; then
    read -p "🗑️ Found orphaned packages. Remove them? [y/N] " -r remove_orphans
    if [[ "$remove_orphans" =~ ^[Yy]$ ]]; then
        sudo pacman -Rns $orphans --noconfirm
    fi
fi

echo ""
echo "✅ Update process complete!"
echo "You can close this window now."
