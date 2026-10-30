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
            :i:m:g:*)       "${0}" --image-history; return ;;
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

# Check for binary content in text mode
check_content() {
    local line
    read -r line
    if [[ $line == *"[[ binary data"* ]]; then
        cliphist decode <<<"$line" | wl-copy
        notify_image_restored "$line"
        return 1
    fi
}

# Notify with the cached thumbnail (written by cliphist.image.py) when one exists
notify_image_restored() {
    local img_idx thumb
    img_idx=$(awk -F '\t' '{print $1}' <<<"$1")
    thumb="${XDG_RUNTIME_DIR}/cliphist/${img_idx}.thumb.png"
    if [ -f "$thumb" ]; then
        notify-send -a "Clipboard" "Image restored to clipboard" -i "$thumb" -t 1500
    else
        notify-send -a "Clipboard" "Image restored to clipboard" -t 1500
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
        -kb-custom-1 "Alt+v" \
        "$@"
    local code=$?
    if [ $code -eq 10 ]; then
        echo ":t:o:g:g:l:e:"
    fi
}

# Setup rofi theme config
setup_rofi_config() {
    local font_scale="${ROFI_CLIPHIST_SCALE}"
    [[ "${font_scale}" =~ ^[0-9]+$ ]] || font_scale=${ROFI_SCALE:-10}

    local font_name=${ROFI_CLIPHIST_FONT:-$ROFI_FONT}
    font_name=${font_name:-"JetBrainsMono Nerd Font"}

    font_override="* {font: \"${font_name} ${font_scale}\";}"
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

# Clipboard text history
show_history() {
    local selected_item
    selected_item=$( (
            echo -e ":i:m:g:\t🖼️ Image History (Alt+V)"
            echo -e ":f:a:v:\t⭐ Favorites"
            echo -e ":o:p:t:\t⚙️ Options"
            cliphist list | grep -v '\[\[ binary data'
    ) | run_rofi "History..." -multi-select -i -display-columns 2 -selected-row 3)

    [ -n "$selected_item" ] || exit 0

    case "$selected_item" in
        ":t:o:g:g:l:e:"|:i:m:g:*) show_image_history; return ;;
        :f:a:v:*) view_favorites; return ;;
        :o:p:t:*) main ""; return ;;
    esac

    if echo -e "${selected_item}" | check_content; then
        process_selections <<<"${selected_item}"
        cliphist delete <<<"${selected_item}"
    fi
}

# Visual image gallery: one large preview per page; arrows or wheel flip between images
show_image_history() {
    local script_path="$HOME/dotfiles/scripts/cliphist.image.py"

    local selected_item
    selected_item=$(python3 "$script_path" | run_rofi "Images (Alt+V for text)" \
        -show-icons \
        -display-columns 2 \
        -theme-str 'window { width: 50em; height: 36em; }' \
        -theme-str 'mainbox { padding: 0.4em; spacing: 0.3em; }' \
        -theme-str 'wallbox { children: [ "inputbar" ]; }' \
        -theme-str 'entry { padding: 0.5em 0.8em; }' \
        -theme-str 'listbox { children: [ "listview" ]; }' \
        -theme-str 'listview { columns: 1; lines: 1; spacing: 0.2em; expand: true; flow: horizontal; scrollbar: true; }' \
        -theme-str 'scrollbar { handle-width: 4px; handle-color: @main-br; background-color: transparent; border-radius: 4px; margin: 0 0 0 0.4em; }' \
        -theme-str 'element { orientation: vertical; padding: 0.4em; spacing: 0.4em; border-radius: 10px; background-color: transparent; }' \
        -theme-str 'element selected.normal { background-color: transparent; border: 0px; }' \
        -theme-str 'element-icon { size: 28em; horizontal-align: 0.5; cursor: inherit; background-color: transparent; }' \
        -theme-str 'element-text { horizontal-align: 0.5; cursor: inherit; }' \
        -theme-str 'element-text selected.normal { background-color: @select-bg; text-color: @select-fg; border-radius: 6px; padding: 0.2em 0.8em; }')

    [ -n "$selected_item" ] || exit 0

    case "$selected_item" in
        ":t:o:g:g:l:e:") show_history; return ;;
    esac

    # Notify before delete+copy: the copy re-adds the image under a new id and
    # the old thumbnail is pruned on the next gallery open.
    notify_image_restored "$selected_item"
    cliphist decode <<<"$selected_item" | wl-copy
    cliphist delete <<<"$selected_item"
}

# Delete history items
delete_items() {
    export del_mode=true
    cliphist list | run_rofi "Delete" -multi-select -i -display-columns 2 | process_selections
}

# View favorites
view_favorites() {
    prepare_favorites_for_display || { notify-send "No favorites."; return; }
    local sel
    sel=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "View Favorites")
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
    item=$(cliphist list | run_rofi "Add to Favorites...")
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
    action=$(echo -e "Add to Favorites\nDelete from Favorites\nClear All Favorites" | run_rofi "Manage Favorites")
    case "$action" in
        "Add to Favorites") add_to_favorites ;;
        "Delete from Favorites") delete_from_favorites ;;
        "Clear All Favorites") : >"$favorites_file" && notify-send "Cleared." ;;
    esac
}

# Clear history
clear_history() {
    local confirm
    confirm=$(echo -e "Yes\nNo" | run_rofi "Clear Clipboard History?")
    [ "$confirm" = "Yes" ] && cliphist wipe && notify-send "Clipboard history cleared."
}

# Help
show_help() {
    cat <<EOF
Options:
  -c  | --copy          Show text clipboard history
  -i  | --image-history Show visual image gallery
  -d  | --delete        Delete selected history items
  -f  | --favorites     View favorites
  -mf | --manage-fav    Manage favorites
  -w  | --wipe          Clear history
  -h  | --help          Show help
EOF
}

# Main
main() {
    setup_rofi_config
    local action="${1:-}"
    if [ -z "$action" ]; then
        action=$(echo -e "History\nImage History\nDelete\nView Favorites\nManage Favorites\nClear History" | run_rofi "Choose action")
    fi
    case "$action" in
        -c|--copy|"History") show_history ;;
        -i|--image-history|"Image History") show_image_history ;;
        -d|--delete|"Delete") delete_items ;;
        -f|--favorites|"View Favorites") view_favorites ;;
        -mf|--manage-fav|"Manage Favorites") manage_favorites ;;
        -w|--wipe|"Clear History") clear_history ;;
        -h|--help) show_help ;;
        *) show_help ;;
    esac
}

main "$@"
