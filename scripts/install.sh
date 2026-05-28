#!/usr/bin/env bash

#!/usr/bin/env bash

# --- 2. GHOSTTY RE-WRAP (only if we’re NOT already inside Ghostty) ---
if [ -z "$GHOSTTY_RESOURCES_DIR" ]; then
    command -v ghostty >/dev/null || {
        notify-send "System Update" "Ghostty terminal is not installed." -u critical
        exit 1
    }
    # Using --title for the window title and -e for execution
    ghostty --title="${GHOSTTY_TITLE:-system-update}" -e bash "$0"
    exit 0
fi

# --- 3. UPDATE LOGIC (now we’re definitely inside Ghostty) ---
set -e
error_handler() {
    local code=$?
    notify-send "System Update" "Error $code – check Ghostty window." -u critical
    echo "❌ Error occurred! Exit code: $code"
    [[ -n "$SUDO_LOOP_PID" ]] && kill "$SUDO_LOOP_PID" 2>/dev/null || true
    exit $code
}
trap error_handler ERR

fastfetch 2>/dev/null || neofetch 2>/dev/null || true

echo "🔐 Authenticating with sudo for system updates..."
sudo -v || { echo "❌ sudo failed"; exit 1; }

( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) &
SUDO_LOOP_PID=$!
trap 'kill "$SUDO_LOOP_PID" 2>/dev/null || true' EXIT

notify-send "System Update" "Updates starting now..." -u normal

# --- 4. PACMAN UPDATE (with early-exit check) ---
echo "📦 Checking for pacman updates..."
sudo pacman -Sy >/dev/null                     # refresh sync DB only
UPDATES=$(pacman -Qu 2>/dev/null | wc -l)      # count upgradable packages

if [ "$UPDATES" -eq 0 ]; then
    echo "No pacman updates available. Exiting."
    exit 0
fi

echo "$UPDATES pacman package(s) to upgrade."
sudo pacman -Su --noconfirm
REBOOT_NEEDED=1

# --- 5. AUR UPDATES ---
if command -v yay >/dev/null; then
    echo "📦 Checking for AUR updates (yay)..."
    AUR_UPDATES=$(yay -Qua 2>/dev/null | wc -l)
    if [ "$AUR_UPDATES" -gt 0 ]; then
        echo "$AUR_UPDATES AUR package(s) to upgrade."
        yay -Su --noconfirm
        REBOOT_NEEDED=1
    fi
elif command -v paru >/dev/null; then
    echo "📦 Checking for AUR updates (paru)..."
    AUR_UPDATES=$(paru -Qua 2>/dev/null | wc -l)
    if [ "$AUR_UPDATES" -gt 0 ]; then
        echo "$AUR_UPDATES AUR package(s) to upgrade."
        paru -Su --noconfirm
        REBOOT_NEEDED=1
    fi
fi

# --- 6. FLATPAK UPDATES (never trigger reboot) ---
command -v flatpak >/dev/null && flatpak update -y

# --- 7. ORPHAN CLEAN-UP ---
orphans=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$orphans" ]; then
    echo "Found orphans: $orphans"
    read -p "🗑️ Remove them? [y/N] " -r
    [[ $REPLY =~ ^[Yy]$ ]] && sudo pacman -Rns $orphans --noconfirm
else
    echo "No orphaned packages found!"
fi

echo ""
echo "✅ Update process complete!"

# --- 8. FINAL FASTFETCH & CONDITIONAL REBOOT PROMPT ---
if [[ "${REBOOT_NEEDED}" == "1" ]]; then
    fastfetch 2>/dev/null || neofetch 2>/dev/null || true
    echo ""
    read -p "🔄 Reboot now? [y/N] " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Rebooting..."
        systemctl reboot
    else
        echo "You can close this Kitty window."
        exit 0
    fi
else
    echo "Nothing that needs a reboot was changed. Exiting."
fi
