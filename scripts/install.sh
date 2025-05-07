#!/bin/bash

# Terminal settings for ghostty
GHOSTTY_TERM="ghostty"

# Function to check if we're running in ghostty
check_terminal() {
    if ! command -v ghostty >/dev/null 2>&1; then
        echo "Ghostty terminal is not installed."
        exit 1
    fi
}

# Function to show notification
show_notification() {
    notify-send "System Update" "$1" -u normal
}

# Create a new ghostty window for updates
create_update_window() {
    ghostty -- "$@"
}

# Main update function
update_system() {
    # Update pacman databases first
    sudo pacman -Sy

    echo "🔄 Starting system updates..."

    # Pacman updates
    echo "📦 Checking official repository updates..."
    sudo pacman -Syu --noconfirm

    # YAY AUR updates
    if command -v yay >/dev/null 2>&1; then
        echo "📦 Checking AUR updates..."
        yay -Sua --noconfirm
    else
        echo "⚠️ YAY is not installed. Skipping AUR updates."
    fi

    # Flatpak updates
    if command -v flatpak >/dev/null 2>&1; then
        echo "📦 Checking Flatpak updates..."
        flatpak update -y
    else
        echo "⚠️ Flatpak is not installed. Skipping Flatpak updates."
    fi

    # Clean package cache to free up space
    echo "🧹 Cleaning up package cache..."
    sudo pacman -Sc --noconfirm

    if command -v yay >/dev/null 2>&1; then
        yay -Sc --noconfirm
    fi

    echo "✅ System update completed!"

    # Wait for user input before closing
    echo "Press any key to close this window..."
    read -n 1 -s
}

# Check if we're in ghostty
check_terminal

# Create a new ghostty window and run updates
create_update_window /bin/bash -c "$(declare -f update_system); update_system"
