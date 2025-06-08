#!/usr/bin/env bash

# define paths and files
cache_dir="${HYDE_CACHE_HOME:-$HOME/.cache/hyde}"
favorites_file="${cache_dir}/landing/cliphist_favorites"
[ -f "$HOME/.cliphist_favorites" ] && favorites_file="$HOME/.cliphist_favorites"
cliphist_style="${ROFI_CLIPHIST_STYLE:-DarkBlue}"
del_mode=false

# Missing paste_string function
paste_string() {
    if command -v wtype >/dev/null 2>&1; then
        wtype -M ctrl -k v
    elif command -v xdotool >/dev/null 2>&1; then
        xdotool key ctrl+v
    fi
}

# process clipboard selections for multi-select mode
process_selections() {
    if [ true != "${del_mode}" ]; then
        mapfile -t lines
        total_lines=${#lines[@]}

        if [[ "${lines[0]}" = ":d:e:l:e:t:e:"* ]]; then
            "${0}" --delete
            return
        elif [[ "${lines[0]}" = ":w:i:p:e:"* ]]; then
            "${0}" --wipe
            return
        elif [[ "${lines[0]}" = *":c:o:p:y:"* ]]; then
            "${0}" --copy
            return
        elif [[ "${lines[0]}" = ":f:a:v:"* ]]; then
            "${0}" --favorites
            return
        elif [[ "${lines[0]}" = ":o:p:t:"* ]]; then
            "${0}"
            return
        fi

        local output=""
        for ((i = 0; i < total_lines; i++)); do
            local line="${lines[$i]}"
            local decoded_line
            decoded_line="$(echo -e "$line\t" | cliphist decode)"
            if [ $i -lt $((total_lines - 1)) ]; then
                printf -v output '%s%s\n' "$output" "$decoded_line"
            else
                printf -v output '%s%s' "$output" "$decoded_line"
            fi
        done
        echo -n "$output"
    else
        while IFS= read -r line; do
            if [[ "${line}" = ":w:i:p:e:"* ]]; then
                "${0}" --wipe
                break
            elif [[ "${line}" = ":b:a:r:"* ]]; then
                "${0}" --delete
                break
            elif [ -n "$line" ]; then
                cliphist delete <<<"${line}"
                notify-send "Deleted" "${line}"
            fi
        done
        exit 0
    fi
}

check_content() {
    local line
    read -r line
    if [[ ${line} == *"[[ binary data"* ]]; then
        cliphist decode <<<"$line" | wl-copy
        local img_idx
        img_idx=$(awk -F '\t' '{print $1}' <<<"$line")
        local temp_preview="${XDG_RUNTIME_DIR:-/tmp}/pastebin-preview_${img_idx}"
        wl-paste >"${temp_preview}"
        notify-send -a "Pastebin:" "Preview: ${img_idx}" -i "${temp_preview}" -t 2000
        return 1
    fi
}

run_rofi() {
    local placeholder="$1"
    shift

    # Simple rofi call without custom theme to avoid theme file errors
    rofi -dmenu \
        -theme-str "entry { placeholder: \"${placeholder}\";}" \
        -theme-str "${font_override:-}" \
        -theme-str "${r_override:-}" \
        -theme-str "${rofi_position:-}" \
        "$@"
}

setup_rofi_config() {
    local font_scale="${ROFI_CLIPHIST_SCALE:-${ROFI_SCALE:-10}}"
    local font_name="${ROFI_CLIPHIST_FONT:-${ROFI_FONT:-"JetBrainsMono Nerd Font"}}"

    font_override="* {font: \"${font_name} ${font_scale}\";}"

    # Use default border sizes (or zero) since no hyprctl
    local hypr_border=0
    local wind_border=$((hypr_border * 3 / 2))
    local elem_border=$((hypr_border == 0 ? 5 : hypr_border))

    rofi_position="" # no custom position, use rofi default

    local hypr_width=1
    r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;}wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"
}

ensure_favorites_dir() {
    local dir
    dir=$(dirname "$favorites_file")
    [ -d "$dir" ] || mkdir -p "$dir"
}

prepare_favorites_for_display() {
    if [ ! -f "$favorites_file" ] || [ ! -s "$favorites_file" ]; then
        return 1
    fi

    mapfile -t favorites <"$favorites_file"
    decoded_lines=()
    for favorite in "${favorites[@]}"; do
        local decoded_favorite
        decoded_favorite=$(echo "$favorite" | base64 --decode)
        local single_line_favorite
        single_line_favorite=$(echo "$decoded_favorite" | tr '\n' ' ')
        decoded_lines+=("$single_line_favorite")
    done

    return 0
}

show_history() {
    local selected_item
    selected_item=$( (
            echo -e ":f:a:v:\t📌 Favorites"
            echo -e ":o:p:t:\t⚙️ Options"
            cliphist list
    ) | run_rofi " 📜 History..." -multi-select -i -display-columns 2 -selected-row 2)

    [ -n "${selected_item}" ] || exit 0

    if echo -e "${selected_item}" | check_content; then
        process_selections <<<"${selected_item}" | wl-copy
        paste_string "${@}"
        echo -e "${selected_item}\t" | cliphist delete
    else
        paste_string "${@}"
        exit 0
    fi
}

delete_items() {
    export del_mode=true
    cliphist list | run_rofi " 🗑️ Delete" -multi-select -i -display-columns 2 | process_selections
}

view_favorites() {
    prepare_favorites_for_display || {
        notify-send "No favorites."
        return
    }

    local selected_favorite
    selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "📌 View Favorites")

    if [ -n "$selected_favorite" ]; then
        local index
        index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)

        if [ -n "$index" ]; then
            local selected_encoded_favorite="${favorites[$((index - 1))]}"
            echo "$selected_encoded_favorite" | base64 --decode | wl-copy
            paste_string "${@}"
            notify-send "Copied to clipboard."
        else
            notify-send "Error: Selected favorite not found."
        fi
    fi
}

add_to_favorites() {
    ensure_favorites_dir

    local item
    item=$(cliphist list | run_rofi "➕ Add to Favorites...")

    if [ -n "$item" ]; then
        local full_item
        full_item=$(echo "$item" | cliphist decode)

        local encoded_item
        encoded_item=$(echo "$full_item" | base64 -w 0)

        if [ -f "$favorites_file" ] && grep -Fxq "$encoded_item" "$favorites_file"; then
            notify-send "Item is already in favorites."
        else
            echo "$encoded_item" >>"$favorites_file"
            notify-send "Added to favorites."
        fi
    fi
}

delete_from_favorites() {
    prepare_favorites_for_display || {
        notify-send "No favorites to remove."
        return
    }

    local selected_favorite
    selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "➖ Remove from Favorites...")

    if [ -n "$selected_favorite" ]; then
        local index
        index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)

        if [ -n "$index" ]; then
            local selected_encoded_favorite="${favorites[$((index - 1))]}"

            if [ "$(wc -l <"$favorites_file")" -eq 1 ]; then
                : >"$favorites_file"
            else
                grep -vF -x "$selected_encoded_favorite" "$favorites_file" >"${favorites_file}.tmp" &&
                mv "${favorites_file}.tmp" "$favorites_file"
            fi
            notify-send "Item removed from favorites."
        else
            notify-send "Error: Selected favorite not found."
        fi
    fi
}

clear_favorites() {
    if [ -f "$favorites_file" ] && [ -s "$favorites_file" ]; then
        local confirm
        confirm=$(echo -e "Yes\nNo" | run_rofi "☢️ Clear All Favorites?")

        if [ "$confirm" = "Yes" ]; then
            : >"$favorites_file"
            notify-send "All favorites have been deleted."
        fi
    else
        notify-send "No favorites to delete."
    fi
}

manage_favorites() {
    local manage_action
    manage_action=$(echo -e "Add to Favorites\nDelete from Favorites\nClear All Favorites" |
    run_rofi "📓 Manage Favorites")

    case "${manage_action}" in
        "Add to Favorites")
            add_to_favorites
            ;;
        "Delete from Favorites")
            delete_from_favorites
            ;;
        "Clear All Favorites")
            clear_favorites
            ;;
        *)
            [ -n "${manage_action}" ] || return 0
            echo "Invalid action"
            exit 1
            ;;
    esac
}

# Fixed clear_history function
clear_history() {
    local confirm
    confirm=$(echo -e "Yes\nNo" | run_rofi "⚠️ Clear All History?")

    if [ "$confirm" = "Yes" ]; then
        cliphist wipe
        notify-send "Clipboard history cleared."
    fi
}

show_options() {
    local option
    option=$(echo -e "🗑️ Delete Items\n📓 Manage Favorites\n🧹 Clear History" |
    run_rofi "⚙️ Options")

    case "${option}" in
        "🗑️ Delete Items")
            delete_items
            ;;
        "📓 Manage Favorites")
            manage_favorites
            ;;
        "🧹 Clear History")
            clear_history
            ;;
    esac
}

# Main execution logic
main() {
    setup_rofi_config

    case "${1:-}" in
        --delete|-d)
            delete_items
            ;;
        --wipe|-w)
            clear_history
            ;;
        --copy|-c)
            show_history "${@:2}"
            ;;
        --favorites|-f)
            view_favorites "${@:2}"
            ;;
        --manage|-m)
            manage_favorites
            ;;
        --help|-h)
            echo "Usage: $0 [OPTION]"
            echo "Clipboard history manager using cliphist and rofi"
            echo ""
            echo "Options:"
            echo "  -c, --copy      Show clipboard history (default)"
            echo "  -f, --favorites View favorites"
            echo "  -d, --delete    Delete items from history"
            echo "  -w, --wipe      Clear all history"
            echo "  -m, --manage    Manage favorites"
            echo "  -h, --help      Show this help"
            ;;
        *)
            # Check if cliphist is available
            if ! command -v cliphist >/dev/null 2>&1; then
                notify-send "Error" "cliphist is not installed"
                exit 1
            fi

            # Check if rofi is available
            if ! command -v rofi >/dev/null 2>&1; then
                notify-send "Error" "rofi is not installed"
                exit 1
            fi

            show_history "${@}"
            ;;
    esac
}

# Run main function with all arguments
main "$@"
