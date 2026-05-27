#!/usr/bin/env bash
# browser-mode.sh — Switch between work and personal browser modes
# Work mode: sets Vivaldi as default browser
# Personal mode: sets Zen Browser as default browser

set -eu

MODE_FILE="$HOME/.config/browser-mode"
ROFI_THEME="${ROFI_THEME:-$HOME/.config/rofi/dmenu.rasi}"

show_usage() {
    cat <<EOF
Usage: $(basename "$0") [work|personal|status|rofi]

Switch default browser between work and personal modes:
  work      - Set Vivaldi as default browser (xdg-open)
  personal  - Set Zen Browser as default browser (xdg-open)
  status    - Show current mode
  rofi      - Interactive rofi menu to select mode (default if no args)

Current mode: $(get_current_mode)
EOF
}

get_current_mode() {
    if [ -f "$MODE_FILE" ]; then
        cat "$MODE_FILE"
    else
        echo "unknown"
    fi
}

set_work_mode() {
    echo "Switching to work mode (Vivaldi)..."
    
    # Find vivaldi
    VIVALDI="$(command -v vivaldi-stable || command -v vivaldi || true)"
    
    if [ -z "$VIVALDI" ]; then
        echo "Error: Vivaldi not found. Please install vivaldi-stable or vivaldi."
        exit 1
    fi
    
    # Set as default browser
    xdg-settings set default-web-browser vivaldi-stable.desktop 2>/dev/null || \
    xdg-settings set default-web-browser vivaldi.desktop 2>/dev/null || {
        echo "Warning: Could not set default browser via xdg-settings"
        echo "You may need to set it manually in your system settings"
    }
    
    # Save mode
    echo "work" > "$MODE_FILE"
    echo "Work mode activated. Default browser: Vivaldi"
}

set_personal_mode() {
    echo "Switching to personal mode (Zen Browser)..."
    
    # Find zen browser
    ZEN="$(command -v zen-browser || command -v zen || true)"
    
    if [ -z "$ZEN" ]; then
        echo "Error: Zen Browser not found. Please install zen-browser or zen."
        exit 1
    fi
    
    # Set as default browser
    xdg-settings set default-web-browser zen-browser.desktop 2>/dev/null || \
    xdg-settings set default-web-browser zen.desktop 2>/dev/null || {
        echo "Warning: Could not set default browser via xdg-settings"
        echo "You may need to set it manually in your system settings"
    }
    
    # Save mode
    echo "personal" > "$MODE_FILE"
    echo "Personal mode activated. Default browser: Zen Browser"
}

show_status() {
    MODE="$(get_current_mode)"
    DEFAULT_BROWSER="$(xdg-settings get default-web-browser 2>/dev/null || echo 'unknown')"
    
    cat <<EOF
Current browser mode: $MODE
Default browser (xdg): $DEFAULT_BROWSER

Available modes:
  work     → Vivaldi
  personal → Zen Browser
EOF
}

show_rofi_menu() {
    CURRENT_MODE="$(get_current_mode)"
    
    # Build menu with current mode indicator
    WORK_LABEL="Work Mode (Vivaldi)"
    PERSONAL_LABEL="Personal Mode (Zen Browser)"
    
    if [ "$CURRENT_MODE" = "work" ]; then
        WORK_LABEL="$WORK_LABEL [CURRENT]"
    elif [ "$CURRENT_MODE" = "personal" ]; then
        PERSONAL_LABEL="$PERSONAL_LABEL [CURRENT]"
    fi
    
    # Show rofi menu
    choice=$(printf "%s\n%s\n" "$WORK_LABEL" "$PERSONAL_LABEL" | \
             rofi -dmenu -p "Browser Mode:" -theme "$ROFI_THEME" || true)
    
    [ -n "$choice" ] || exit 0
    
    # Parse choice and switch mode
    case "$choice" in
        Work*|work*)
            set_work_mode
            notify-send -u normal "Browser Mode" "Switched to Work mode (Vivaldi)" 2>/dev/null || true
            ;;
        Personal*|personal*)
            set_personal_mode
            notify-send -u normal "Browser Mode" "Switched to Personal mode (Zen Browser)" 2>/dev/null || true
            ;;
        *)
            echo "Unknown selection: $choice"
            exit 1
            ;;
    esac
}

# Main
case "${1:-rofi}" in
    work)
        set_work_mode
        ;;
    personal)
        set_personal_mode
        ;;
    status)
        show_status
        ;;
    rofi)
        show_rofi_menu
        ;;
    -h|--help|help)
        show_usage
        ;;
    *)
        echo "Error: Unknown mode '$1'"
        echo ""
        show_usage
        exit 1
        ;;
esac
