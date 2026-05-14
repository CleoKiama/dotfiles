#!/usr/bin/env bash

# Exit if rofi is already open
pgrep -u "$USER" rofi >/dev/null && exit 0

# Optional Hyde-shell init
[[ "${HYDE_SHELL_INIT}" -ne 1 ]] && type hyde-shell &>/dev/null && eval "$(hyde-shell init)"

# Paths
cache_dir="${HYDE_CACHE_HOME:-$HOME/.cache/hyde}"
favorites_file="${cache_dir}/landing/cliphist_favorites"
[ -f "$HOME/.cliphist_favorites" ] && favorites_file="$HOME/.cliphist_favorites"
cliphist_style="$HOME/dotfiles/scripts/rofiTheme/theme.rasinc"
del_mode=false

# Process clipboard selections
process_selections() {
    if [ true != "${del_mode}" ]; then
        mapfile -t lines
        total_lines=${#lines[@]}

        case "${lines[0]}" in
            :d:e:l:e:t:e:*) "${0}" --delete; return ;;
            :w:i:p:e:*)     "${0}" --wipe; return ;;
            :b:a:r:*|*:c:o:p:y:*) "${0}" --copy; return ;;
            :f:a:v:*)       "${0}" --favorites; return ;;
            :o:p:t:*)       "${0}"; return ;;
        esac

        local output=""
        for ((i = 0; i < total_lines; i++)); do
            local line="${lines[$i]}"
            local decoded_line
            decoded_line="$(echo -e "$line\t" | cliphist decode)"
            printf -v output '%s%s%s' "$output" "$decoded_line" $([ $i -lt $((total_lines-1)) ] && echo -e "\n")
        done
        wl-copy <<<"$output"
    else
        while IFS= read -r line; do
            case "$line" in
                :w:i:p:e:*) "${0}" --wipe; break ;;
                :b:a:r:*)   "${0}" --delete; break ;;
                *)
                    [ -n "$line" ] && cliphist delete <<<"$line" && notify-send "Deleted" "$line"
                    ;;
            esac
        done
    fi
}

# Check for binary content
check_content() {
    local line
    read -r line
    if [[ $line == *"[[ binary data"* ]]; then
        cliphist decode <<<"$line" | wl-copy
        local img_idx
        img_idx=$(awk -F '\t' '{print $1}' <<<"$line")
        local temp_preview="${XDG_RUNTIME_DIR}/hyde/pastebin-preview_${img_idx}"
        wl-paste >"${temp_preview}"
        notify-send -a "Pastebin:" "Preview: ${img_idx}" -i "${temp_preview}" -t 2000
        return 1
    fi
}

# Run rofi
run_rofi() {
    local placeholder="$1"; shift
    rofi -dmenu \
        -theme-str "entry { placeholder: \"${placeholder}\";}" \
        -theme-str "${font_override}" \
        -theme-str "${r_override}" \
        -theme-str "${rofi_position}" \
        -theme "${cliphist_style}" \
        "$@"
}

# Setup rofi theme config from Hyprland
setup_rofi_config() {
    local font_scale="${ROFI_CLIPHIST_SCALE}"
    [[ "${font_scale}" =~ ^[0-9]+$ ]] || font_scale=${ROFI_SCALE:-10}

    local font_name=${ROFI_CLIPHIST_FONT:-$ROFI_FONT}
    font_name=${font_name:-"JetBrainsMono Nerd Font"}

    font_override="* {font: \"${font_name} ${font_scale}\";}"

    # fallback styles since Niri has no hyprctl
    rofi_position="window { location: center; }"
    r_override="window{border:2px;border-radius:8px;} element{border-radius:4px;}"
}

# Favorites helpers
ensure_favorites_dir() {
    mkdir -p "$(dirname "$favorites_file")"
}

prepare_favorites_for_display() {
    [ -s "$favorites_file" ] || return 1
    mapfile -t favorites <"$favorites_file"
    decoded_lines=()
    for fav in "${favorites[@]}"; do
        decoded_lines+=("$(echo "$fav" | base64 --decode | tr '\n' ' ')")
    done
}

# Clipboard history
show_history() {
    local selected_item
    selected_item=$( (
            echo -e ":f:a:v:\t📌 Favorites"
            echo -e ":o:p:t:\t⚙️ Options"
            cliphist list
    ) | run_rofi " 📜 History..." -multi-select -i -display-columns 2 -selected-row 2)

    [ -n "$selected_item" ] || exit 0

    if echo -e "${selected_item}" | check_content; then
        process_selections <<<"${selected_item}"
        cliphist delete <<<"${selected_item}"
    fi
}

# Delete history items
delete_items() {
    export del_mode=true
    cliphist list | run_rofi " 🗑️ Delete" -multi-select -i -display-columns 2 | process_selections
}

# View favorites
view_favorites() {
    prepare_favorites_for_display || { notify-send "No favorites."; return; }
    local sel
    sel=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "📌 View Favorites")
    [ -n "$sel" ] || return
    local idx
    idx=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$sel" | cut -d: -f1)
    [ -n "$idx" ] || { notify-send "Error: Not found."; return; }
    echo "${favorites[$((idx - 1))]}" | base64 --decode | wl-copy
    notify-send "Copied to clipboard."
}

# Add to favorites
add_to_favorites() {
    ensure_favorites_dir
    local item
    item=$(cliphist list | run_rofi "➕ Add to Favorites...")
    [ -n "$item" ] || return
    local full_item encoded_item
    full_item=$(echo "$item" | cliphist decode)
    encoded_item=$(echo "$full_item" | base64 -w 0)
    grep -Fxq "$encoded_item" "$favorites_file" 2>/dev/null && { notify-send "Already in favorites."; return; }
    echo "$encoded_item" >>"$favorites_file"
    notify-send "Added to favorites."
}

# Manage favorites
manage_favorites() {
    local action
    action=$(echo -e "Add to Favorites\nDelete from Favorites\nClear All Favorites" | run_rofi "📓 Manage Favorites")
    case "$action" in
        "Add to Favorites") add_to_favorites ;;
        "Delete from Favorites") delete_from_favorites ;;
        "Clear All Favorites") : >"$favorites_file" && notify-send "Cleared." ;;
    esac
}

# Clear history
clear_history() {
    local confirm
    confirm=$(echo -e "Yes\nNo" | run_rofi "☢️ Clear Clipboard History?")
    [ "$confirm" = "Yes" ] && cliphist wipe && notify-send "Clipboard history cleared."
}

# Help
show_help() {
    cat <<EOF
Options:
  -c  | --copy       Show clipboard history
  -d  | --delete     Delete selected history items
  -f  | --favorites  View favorites
  -mf | --manage-fav Manage favorites
  -w  | --wipe       Clear history
  -h  | --help       Show help
EOF
}

# Main
main() {
    setup_rofi_config
    local action="${1:-}"
    if [ -z "$action" ]; then
        action=$(echo -e "History\nDelete\nView Favorites\nManage Favorites\nClear History" | run_rofi "🔎 Choose action")
    fi
    case "$action" in
        -c|--copy|"History") show_history ;;
        -d|--delete|"Delete") delete_items ;;
        -f|--favorites|"View Favorites") view_favorites ;;
        -mf|--manage-fav|"Manage Favorites") manage_favorites ;;
        -w|--wipe|"Clear History") clear_history ;;
        -h|--help|*) show_help ;;
    esac
}

main "$@"
