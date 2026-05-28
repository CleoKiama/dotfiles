#!/usr/bin/env bash
# rofi-tmux.sh — Pick and attach to a tmux session
# Adapted from dmenu-scripts/tmux-rofi.sh for rofi + ghostty

set -eu

ROFI_THEME="${ROFI_THEME:-$HOME/.config/rofi/dmenu.rasi}"
TERMINAL="${ROFI_TMUX_TERMINAL:-ghostty}"

# List active sessions
sessions="$(tmux list-sessions -F '#S' 2>/dev/null || true)"
[ -n "$sessions" ] || {
  # No sessions — offer to create one
  name="$(echo "" | rofi -dmenu -p 'No sessions. Create new:' -theme "$ROFI_THEME" || true)"
  [ -n "$name" ] || exit 0
  exec "$TERMINAL" -e tmux new-session -s "$name"
}

# Pick session
chosen="$(printf '%s\n' "$sessions" | rofi -dmenu -i -p 'tmux sessions:' -theme "$ROFI_THEME" || true)"
[ -n "$chosen" ] || exit 0

# Already inside tmux? Just switch
if [ -n "${TMUX-}" ]; then
  exec tmux switch-client -t "$chosen"
fi

# Try to find an existing ghostty client and switch it
client_tty="$(
  tmux list-clients -F '#{client_tty} #{client_name}' 2>/dev/null \
  | grep -i ghostty | head -1 | awk '{print $1}' || true
)"

if [ -n "$client_tty" ]; then
  tmux switch-client -c "$client_tty" -t "$chosen"
  exit 0
fi

# Open a new terminal and attach
exec "$TERMINAL" -e tmux attach -t "$chosen"
