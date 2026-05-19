#!/usr/bin/env bash
# rofi-repos.sh — Pick a project repo and open in terminal + tmux
# Adapted from dmenu-scripts/repos-rofi.sh for rofi + ghostty

set -eu

ROFI_THEME="${ROFI_THEME:-$HOME/.config/rofi/dmenu.rasi}"
TERMINAL="${ROFI_REPOS_TERMINAL:-ghostty}"
REPO_DIR="${ROFI_REPOS_DIR:-$HOME/repos}"

# List project directories
repos="$(ls -1d "$REPO_DIR"/*/ 2>/dev/null | xargs -n1 basename || true)"
[ -n "$repos" ] || exit 0

# Pick repo
chosen="$(printf '%s\n' "$repos" | rofi -dmenu -i -p 'Projects:' -theme "$ROFI_THEME" || true)"
[ -n "$chosen" ] || exit 0

dir="$REPO_DIR/$chosen"

# Open in terminal with tmux (attach if session exists, else create)
exec "$TERMINAL" -e tmux new-session -As "$chosen" -c "$dir"
