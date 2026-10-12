#!/usr/bin/env bash

set -euo pipefail

# Default delay: 30 minutes if not specified
DELAY="${1:-30m}"

echo "Sleep timer started: will pause media and suspend in ${DELAY}."
echo "Press Ctrl+C at any time to cancel."

# Wait for the specified duration (supports s, m, h - e.g., 45m, 1h, 3600)
sleep "${DELAY}"

echo "Timeout reached. Pausing media..."
# Pause all active MPRIS-compatible media players silently
playerctl -a pause 3>/dev/null || true

# Give players a split-second to finish processing the pause signal
sleep 3

echo "Suspending system..."
loginctl poweroff
