#!/usr/bin/env bash
# rofi-ssh.sh — Pick SSH host and connect via ghostty

set -eu

ROFI_THEME="${ROFI_SSH_THEME:-$HOME/.config/rofi/dmenu.rasi}"
TERMINAL="${ROFI_SSH_TERMINAL:-ghostty}"
SSH_CONFIG="$HOME/.ssh/config"

# Parse hosts from ~/.ssh/config
hosts=""
if [ -f "$SSH_CONFIG" ]; then
  hosts="$(grep -E '^Host ' "$SSH_CONFIG" | awk '{print $2}' | grep -vE '\*|!')"
fi

# Also pull unique entries from known_hosts as fallback
known=""
if [ -f "$HOME/.ssh/known_hosts" ]; then
  known="$(awk '{print $1}' "$HOME/.ssh/known_hosts" | grep -vE ',|^\[|^\*' | sort -u)"
fi

# Combine and deduplicate
all_hosts="$(printf '%s\n%s\n' "$hosts" "$known" | grep -v '^$' | sort -u)"
[ -n "$all_hosts" ] || exit 0

# Pick host
chosen="$(printf '%s\n' "$all_hosts" | rofi -dmenu -i -p 'SSH:' -theme "$ROFI_THEME" || true)"
[ -n "$chosen" ] || exit 0

exec "$TERMINAL" -e ssh "$chosen"
