#!/usr/bin/env bash
# rofi-bookmarks.sh — Pick bookmarks and open in browser
# Adapted from dmenu-scripts/bookmarks-rofi.sh for rofi + zen-browser

set -eu

# --- Config ---
PERS_FILE="${PERS_FILE:-$HOME/.config/bookmarks/personal.txt}"
WORK_FILE="${WORK_FILE:-$HOME/.config/bookmarks/work.txt}"
ROFI_THEME="${ROFI_THEME:-$HOME/.config/rofi/dmenu.rasi}"

# Browsers — zen-browser is default, fallback to xdg-open
ZEN="$(command -v zen-browser || command -v zen || true)"
FALLBACK="$(command -v xdg-open || command -v firefox || echo xdg-open)"

# Ensure bookmark files exist
mkdir -p "$(dirname "$PERS_FILE")"
[ -f "$PERS_FILE" ] || cat >"$PERS_FILE" <<'EOF'
# personal bookmarks
# format: display name :: url
GitHub :: https://github.com
YouTube :: https://youtube.com
Reddit :: https://reddit.com
EOF

[ -f "$WORK_FILE" ] || cat >"$WORK_FILE" <<'EOF'
# work bookmarks
# format: display name :: url
EOF

# --- Build combined list ---
emit() {
  local tag="$1" file="$2"
  [ -f "$file" ] || return 0
  grep -vE '^\s*(#|$)' "$file" | while IFS= read -r line; do
    case "$line" in
      *"::"*)
        lhs="${line%%::*}"; rhs="${line#*::}"
        lhs="$(printf '%s' "$lhs" | sed 's/[[:space:]]*$//')"
        rhs="$(printf '%s' "$rhs" | sed 's/^[[:space:]]*//')"
        printf '[%s] %s :: %s\n' "$tag" "$lhs" "$rhs"
        ;;
      *)
        printf '[%s] %s :: %s\n' "$tag" "$line" "$line"
        ;;
    esac
  done
}

choice="$({
  emit personal "$PERS_FILE"
  emit work     "$WORK_FILE"
} | sort | rofi -dmenu -p 'Bookmarks:' -theme "$ROFI_THEME" || true)"

[ -n "$choice" ] || exit 0

# --- Parse choice ---
tag="${choice%%]*}"; tag="${tag#\[}"
raw="${choice##* :: }"

# Strip inline comments and trim
raw="$(printf '%s' "$raw" \
  | sed -e 's/[[:space:]]\+#.*$//' -e 's/[[:space:]]\/\/.*$//' \
        -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# Ensure scheme
case "$raw" in
  http://*|https://*|file://*|about:*|chrome:*) url="$raw" ;;
  *) url="https://$raw" ;;
esac

# --- Open ---
if [ -n "$ZEN" ]; then
  nohup "$ZEN" --new-tab "$url" >/dev/null 2>&1 &
else
  nohup $FALLBACK "$url" >/dev/null 2>&1 &
fi
