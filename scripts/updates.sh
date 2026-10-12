#!/usr/bin/env bash
# ==============================================================================
# Waybar System Updates Module
# Supports: Official repositories (checkupdates / paru / pacman), AUR (paru / yay), Flatpak
# ==============================================================================

set -u

# Check options
DEBUG=false
PLAIN=false
for arg in "$@"; do
    case "$arg" in
        --debug) DEBUG=true ;;
        --plain|--check) PLAIN=true ;;
    esac
done

debug_log() {
    if [ "$DEBUG" = true ]; then
        echo "[DEBUG] $1" >&2
    fi
}

# Thresholds for Waybar styling classes
threshold_yellow=25
threshold_red=100

# Temporary workspace for parallel queries
TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/waybar-updates.XXXXXX")
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

repo_file="$TMP_DIR/repo.txt"
aur_file="$TMP_DIR/aur.txt"
flatpak_file="$TMP_DIR/flatpak.txt"

# ------------------------------------------------------------------------------
# 1. Check Official Repositories
# Prefers checkupdates (from pacman-contrib) because it syncs safely to a temp DB
# without root privileges or modifying the system pacman sync database.
# ------------------------------------------------------------------------------
check_repo() {
    debug_log "Starting repo updates check..."
    if command -v checkupdates >/dev/null 2>&1; then
        # checkupdates exits 0 on updates, 2 on no updates, 1 on failure
        timeout 25s checkupdates > "$repo_file" 2>/dev/null || true
    elif command -v paru >/dev/null 2>&1; then
        timeout 25s paru -Qu --repo -q > "$repo_file" 2>/dev/null || true
    elif command -v yay >/dev/null 2>&1; then
        timeout 25s yay -Qu --repo --quiet > "$repo_file" 2>/dev/null || true
    elif command -v pacman >/dev/null 2>&1; then
        timeout 25s pacman -Qu -q > "$repo_file" 2>/dev/null || true
    fi
    debug_log "Finished repo updates check."
}

# ------------------------------------------------------------------------------
# 2. Check AUR Updates
# Prefers paru, falls back to yay
# ------------------------------------------------------------------------------
check_aur() {
    debug_log "Starting AUR updates check..."
    if command -v paru >/dev/null 2>&1; then
        timeout 25s paru -Qua -q > "$aur_file" 2>/dev/null || true
    elif command -v yay >/dev/null 2>&1; then
        timeout 25s yay -Qua -q > "$aur_file" 2>/dev/null || true
    fi
    debug_log "Finished AUR updates check."
}

# ------------------------------------------------------------------------------
# 3. Check Flatpak Updates
# ------------------------------------------------------------------------------
check_flatpak() {
    debug_log "Starting Flatpak updates check..."
    if command -v flatpak >/dev/null 2>&1; then
        timeout 20s flatpak remote-ls --updates > "$flatpak_file" 2>/dev/null || true
    fi
    debug_log "Finished Flatpak updates check."
}

# Run all checks concurrently
check_repo & pid_repo=$!
check_aur & pid_aur=$!
check_flatpak & pid_flatpak=$!

wait "$pid_repo" "$pid_aur" "$pid_flatpak" 2>/dev/null || true

# Count non-empty lines
count_lines() {
    local file="$1"
    if [ -f "$file" ]; then
        grep -c '[^[:space:]]' "$file" 2>/dev/null || echo 0
    else
        echo 0
    fi
}

updates_arch=$(count_lines "$repo_file")
updates_aur=$(count_lines "$aur_file")
updates_flatpak=$(count_lines "$flatpak_file")

# Sanitize counts (ensure valid non-negative integers)
updates_arch=$(( updates_arch > 0 ? updates_arch : 0 ))
updates_aur=$(( updates_aur > 0 ? updates_aur : 0 ))
updates_flatpak=$(( updates_flatpak > 0 ? updates_flatpak : 0 ))

total_updates=$(( updates_arch + updates_aur + updates_flatpak ))

debug_log "Counts: repo=$updates_arch, aur=$updates_aur, flatpak=$updates_flatpak, total=$total_updates"

# ------------------------------------------------------------------------------
# Plain CLI Output (if requested via --plain / --check)
# ------------------------------------------------------------------------------
if [ "$PLAIN" = true ]; then
    echo "Total updates: $total_updates"
    echo "  • Official Repos: $updates_arch"
    echo "  • AUR:            $updates_aur"
    echo "  • Flatpak:        $updates_flatpak"
    exit 0
fi

# ------------------------------------------------------------------------------
# JSON Output for Waybar Module custom-updates
# ------------------------------------------------------------------------------
css_class="green"
if [ "$total_updates" -gt "$threshold_red" ]; then
    css_class="red"
elif [ "$total_updates" -gt "$threshold_yellow" ]; then
    css_class="yellow"
fi

if [ "$total_updates" -gt 0 ]; then
    tooltip="$total_updates update(s) available\n• Official Repos: $updates_arch\n• AUR: $updates_aur\n• Flatpak: $updates_flatpak\n\nLeft-click: Update system\nRight-click: Check now"
else
    tooltip="System up to date\nRight-click: Check now"
fi

if command -v jq >/dev/null 2>&1; then
    jq -nc \
        --arg text "$total_updates" \
        --arg alt "$total_updates" \
        --arg tooltip "$(printf '%b' "$tooltip")" \
        --arg class "$css_class" \
        '{text: $text, alt: $alt, tooltip: $tooltip, class: $class}'
else
    # Fallback if jq is unavailable
    escaped_tooltip=$(printf '%s' "$tooltip" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g')
    printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}\n' \
        "$total_updates" "$total_updates" "$escaped_tooltip" "$css_class"
fi
