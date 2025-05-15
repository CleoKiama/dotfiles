#!/usr/bin/env bash
# Arch Linux system update script
# This script performs a comprehensive system update including official repos, AUR, and Flatpak

# Ensure Kitty is installed
if ! command -v kitty >/dev/null 2>&1; then
    notify-send "System Update" "Kitty terminal is not installed." -u critical
    exit 1
fi

# Main update function to be executed within Kitty
main_update_script() {
    set -e  # Exit immediately if a command exits with non-zero status

    # Function to handle errors
    error_handler() {
        local exit_code=$?
        notify-send "System Update" "An error occurred during the update process (code: $exit_code)" -u critical
        echo "❌ Error occurred! Exit code: $exit_code"
        kill "$SUDO_LOOP_PID" 2>/dev/null || true
        exit $exit_code
    }

    # Set up error handling
    trap error_handler ERR

    # Prompt for sudo inside the Kitty terminal
    echo "🔐 Authenticating with sudo for system updates..."
    if ! sudo -v; then
        echo "❌ Failed to authenticate sudo. Exiting."
        exit 1
    fi

    # Keep sudo timestamp alive
    ( while true; do sudo -n true; sleep 60; kill -0 "$" 2>/dev/null || exit; done ) &
    SUDO_LOOP_PID=$!

    # Clean up processes on exit
    trap 'kill "$SUDO_LOOP_PID" 2>/dev/null || true' EXIT

    # Define the update routine
    update_system() {
        # Send a single notification at start
        notify-send "System Update" "Updates starting now..." -u normal

        echo "🖥️ System Information:"
        # Display system info if available
        if command -v fastfetch >/dev/null 2>&1; then
            fastfetch
        elif command -v neofetch >/dev/null 2>&1; then
            neofetch
        fi
        echo ""

        # Fast database fetch
        echo "⏩ Performing fast database fetch (pacman -Fy)..."
        sudo pacman -Fy || echo "⚠️ Database refresh encountered issues but continuing..."
        echo ""

        # Full system update in one step (recommended approach)
        echo "📦 Performing full system update (pacman -Syu)..."
        sudo pacman -Syu --noconfirm
        echo "✅ Official repositories updated successfully!"
        echo ""

        # AUR updates
        if command -v yay >/dev/null 2>&1; then
            echo "📦 Updating AUR packages (yay -Syu)..."
            yay -Syu --noconfirm
            echo "✅ AUR packages updated successfully!"
        elif command -v paru >/dev/null 2>&1; then
            echo "📦 Updating AUR packages (paru -Syu)..."
            paru -Syu --noconfirm
            echo "✅ AUR packages updated successfully!"
        else
            echo "⚠️ No AUR helper (yay/paru) found; skipping AUR updates"
        fi
        echo ""

        # Flatpak updates
        if command -v flatpak >/dev/null 2>&1; then
            echo "📦 Updating Flatpak packages..."
            flatpak update -y
            echo "✅ Flatpak packages updated successfully!"
        else
            echo "⚠️ Flatpak not found; skipping Flatpak updates"
        fi
        echo ""

        # Clean up caches (with confirmation check)
        echo "🧹 Would you like to clean package caches? [y/N]"
        read -r clean_cache
        if [[ "$clean_cache" =~ ^[Yy]$ ]]; then
            echo "Cleaning pacman cache..."
            sudo pacman -Sc --noconfirm

            if command -v yay >/dev/null 2>&1; then
                echo "Cleaning AUR cache..."
                yay -Sc --noconfirm
            elif command -v paru >/dev/null 2>&1; then
                echo "Cleaning AUR cache..."
                paru -Sc --noconfirm
            fi
            echo "✅ Package caches cleaned successfully!"
        else
            echo "Skipping cache cleanup."
        fi
        echo ""

        # Check for orphaned packages
        echo "🔍 Checking for orphaned packages..."
        orphans=$(pacman -Qtdq)
        if [ -n "$orphans" ]; then
            echo "Found orphaned packages. Would you like to remove them? [y/N]"
            read -r remove_orphans
            if [[ "$remove_orphans" =~ ^[Yy]$ ]]; then
                echo "Removing orphaned packages..."
                sudo pacman -Rns $(pacman -Qtdq) --noconfirm
                echo "✅ Orphaned packages removed successfully!"
            else
                echo "Orphaned packages were not removed."
            fi
        else
            echo "No orphaned packages found!"
        fi
        echo ""

        # Update mirrorlist if reflector is installed
        if command -v reflector >/dev/null 2>&1; then
            echo "🔄 Would you like to update the mirrorlist with reflector? [y/N]"
            read -r update_mirrors
            if [[ "$update_mirrors" =~ ^[Yy]$ ]]; then
                echo "Updating mirrorlist..."
                sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
                echo "✅ Mirrorlist updated successfully!"
            else
                echo "Skipping mirrorlist update."
            fi
        fi
        echo ""

    }

    # Run the update system function
    update_system
}

# Launch in a new Kitty window and execute the main script
kitty --title "System Update" --hold bash -c "$(declare -f main_update_script error_handler update_system); main_update_script"
