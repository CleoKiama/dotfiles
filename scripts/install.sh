#!/usr/bin/env bash
# ==============================================================================
# System Update Script
# Performs system upgrade via paru (official repos + AUR), Flatpak, orphan cleanup,
# and intelligent reboot check for Artix/Arch Linux systems.
# ==============================================================================

set -eo pipefail

# ------------------------------------------------------------------------------
# 1. Terminal Re-wrap (spawn Ghostty if not running inside Ghostty / terminal)
# ------------------------------------------------------------------------------
if [ -z "${SYSTEM_UPDATE_WRAPPED:-}" ] && [ -z "${GHOSTTY_RESOURCES_DIR:-}" ]; then
    if ! command -v ghostty >/dev/null 2>&1; then
        notify-send "System Update" "Ghostty terminal is not installed." -u critical 2>/dev/null || true
        echo "❌ Ghostty terminal is not installed." >&2
        exit 1
    fi
    export SYSTEM_UPDATE_WRAPPED=1
    exec ghostty --title="${GHOSTTY_TITLE:-system-update}" -e bash "$0" "$@"
fi

# ------------------------------------------------------------------------------
# 2. Cleanup and Error Traps
# ------------------------------------------------------------------------------
wait_to_exit() {
    if [ -t 0 ]; then
        echo ""
        read -r -p "Press Enter to close window..." _ || true
    fi
}

cleanup() {
    if [[ -n "${SUDO_LOOP_PID:-}" ]]; then
        kill "$SUDO_LOOP_PID" 2>/dev/null || true
        wait "$SUDO_LOOP_PID" 2>/dev/null || true
    fi
}
trap cleanup EXIT INT TERM

error_handler() {
    local code=$?
    notify-send "System Update" "Update failed (exit code $code). Check terminal." -u critical 2>/dev/null || true
    echo ""
    echo "❌ An error occurred! Exit code: $code"
    wait_to_exit
    exit "$code"
}
trap error_handler ERR

# ------------------------------------------------------------------------------
# 3. Initialization & Sudo Authentication
# ------------------------------------------------------------------------------
fastfetch 2>/dev/null || neofetch 2>/dev/null || true
echo "========================================================"
echo "               🚀 System Update Started                 "
echo "========================================================"
echo ""

echo "🔐 Authenticating with sudo for system updates..."
sudo -v || { echo "❌ sudo authentication failed."; wait_to_exit; exit 1; }

# Keep sudo timestamp alive in background during long builds
( while true; do sudo -n true 2>/dev/null; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) &
SUDO_LOOP_PID=$!

notify-send "System Update" "Updates starting now..." -u normal 2>/dev/null || true

# Parse flags
NOCONFIRM=""
for arg in "$@"; do
    case "$arg" in
        --noconfirm|-y) NOCONFIRM="--noconfirm" ;;
    esac
done

# Record baseline for reboot detection
LOG_MARKER=$(wc -l < /var/log/pacman.log 2>/dev/null || echo 0)
RUNNING_KERNEL=$(uname -r)

# ------------------------------------------------------------------------------
# 4. Repository & AUR Updates
# ------------------------------------------------------------------------------
echo ""
if command -v paru >/dev/null 2>&1; then
    echo "📦 Upgrading repository and AUR packages with paru..."
    if [ -n "$NOCONFIRM" ]; then
        paru -Syu --noconfirm --useask
    else
        paru -Syu
    fi
elif command -v yay >/dev/null 2>&1; then
    echo "📦 Upgrading repository and AUR packages with yay..."
    if [ -n "$NOCONFIRM" ]; then
        yay -Syu --noconfirm
    else
        yay -Syu
    fi
else
    echo "📦 Upgrading repository packages with pacman..."
    if [ -n "$NOCONFIRM" ]; then
        sudo pacman -Syu --noconfirm
    else
        sudo pacman -Syu
    fi
fi

# ------------------------------------------------------------------------------
# 5. Flatpak Updates
# ------------------------------------------------------------------------------
if command -v flatpak >/dev/null 2>&1; then
    echo ""
    echo "📦 Checking and updating Flatpak packages..."
    flatpak update -y
fi

# ------------------------------------------------------------------------------
# 6. Orphan Clean-up
# ------------------------------------------------------------------------------
echo ""
echo "🔍 Checking for orphaned packages..."
orphans=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$orphans" ]; then
    echo "Found orphaned packages:"
    echo "$orphans" | sed 's/^/  • /'
    echo ""
    read -p "🗑️ Remove orphaned packages? [y/N] " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Word splitting intended here for package list
        # shellcheck disable=SC2086
        sudo pacman -Rns --noconfirm $orphans || echo "⚠️ Could not remove some orphans."
    else
        echo "Skipping orphan removal."
    fi
else
    echo "✨ No orphaned packages found."
fi

# ------------------------------------------------------------------------------
# 7. Refresh Waybar Updates Module
# ------------------------------------------------------------------------------
pkill -SIGRTMIN+8 waybar 2>/dev/null || true

echo ""
echo "✅ Package operations completed successfully!"
notify-send "System Update" "System update complete." -u normal 2>/dev/null || true

# ------------------------------------------------------------------------------
# 8. Reboot Intelligence & Prompt
# ------------------------------------------------------------------------------
reboot_needed=false
reboot_reasons=()

# Check if running kernel's module directory was removed/replaced
if [ ! -d "/usr/lib/modules/$RUNNING_KERNEL" ]; then
    reboot_needed=true
    reboot_reasons+=("Kernel version upgraded (running: $RUNNING_KERNEL)")
fi

# Check pacman log for critical packages upgraded during this session
CRITICAL_PKGS='linux|linux-lts|linux-zen|linux-hardened|glibc|s6|s6-rc|elogind|udev|eudev|systemd|intel-ucode|amd-ucode|nvidia'
new_upgrades=$(tail -n +"$((LOG_MARKER + 1))" /var/log/pacman.log 2>/dev/null | grep -E "\\[ALPM\\] upgraded ($CRITICAL_PKGS)" || true)

if [ -n "$new_upgrades" ]; then
    reboot_needed=true
    upgraded_names=$(echo "$new_upgrades" | awk '{print $3}' | sort -u | tr '\n' ' ')
    reboot_reasons+=("Core system components upgraded: $upgraded_names")
fi

echo ""
if [ "$reboot_needed" = true ]; then
    echo "⚠️  REBOOT RECOMMENDED:"
    for reason in "${reboot_reasons[@]}"; do
        echo "  • $reason"
    done
    echo ""
    read -p "🔄 Reboot now? [y/N] " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Rebooting system..."
        # Try loginctl reboot (elogind/systemd), then systemctl reboot, then sudo reboot
        if command -v loginctl >/dev/null 2>&1 && loginctl reboot 2>/dev/null; then
            :
        elif command -v systemctl >/dev/null 2>&1 && systemctl reboot 2>/dev/null; then
            :
        else
            sudo reboot
        fi
        exit 0
    else
        echo "Reboot postponed. Please reboot at your earliest convenience."
    fi
else
    echo "✨ No kernel or core system libraries were modified. No reboot required."
fi

wait_to_exit
