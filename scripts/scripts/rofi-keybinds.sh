#!/usr/bin/env bash

set -eu

ROFI_THEME="${ROFI_KEYBINDS_THEME:-$HOME/.config/rofi/dmenu.rasi}"
BINDS_FILE="${MANGO_BINDS:-$HOME/.config/mango/binds.conf}"

[ -f "$BINDS_FILE" ] || exit 1

entries="$(awk '
function trim(s)  { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }

function basename(path,   a, n, b) {
    n = split(path, a, "/")
    b = trim(a[n])
    gsub(/\.sh$/, "", b)
    return b
}

function cmd_desc(args,   a, i, cmd) {
    split(trim(args), a, " ")
    cmd = basename(a[1])
    if (cmd == "rofi") {
        for (i = 2; (i+1) in a; i++) {
            if (a[i] == "-show") return "rofi " a[i+1]
        }
    }
    return cmd
}

function label(action, args,   a, n, title, v) {
    if (action == "spawn" || action == "spawn_shell") return cmd_desc(args)
    if (action == "reload_config")            return "reload config"
    if (action == "killclient")               return "kill window"
    if (action == "quit")                     return "quit mango"
    if (action == "togglefullscreen")         return "fullscreen"
    if (action == "togglefloating")           return "toggle floating"
    if (action == "toggleoverview")           return "overview"
    if (action == "toggleglobal")             return "toggle global"
    if (action == "toggleoverlay")            return "overlay"
    if (action == "togglemaximizescreen")     return "maximize"
    if (action == "togglefakefullscreen")     return "fake fullscreen"
    if (action == "minimized")                return "minimize to scratchpad"
    if (action == "restore_minimized")        return "restore from scratchpad"
    if (action == "toggle_scratchpad")        return "cycle scratchpad"
    if (action == "switch_proportion_preset") return "cycle layout proportions"
    if (action == "focusdir")    { split(args, a, ","); return "focus "         trim(a[1]) }
    if (action == "focusmon")    { split(args, a, ","); return "focus monitor " trim(a[1]) }
    if (action == "focusstack")  {
        split(args, a, ","); v = trim(a[1])
        return "focus " (v == "next" ? "next" : "prev") " window"
    }
    if (action == "exchange_client") { split(args, a, ","); return "swap window " trim(a[1]) }
    if (action == "set_proportion")  { split(args, a, ","); return "set proportion " trim(a[1]) }
    if (action == "resizewin") {
        split(args, a, ","); v = a[1]+0
        return (v < 0 ? "shrink" : "grow") " window"
    }
    if (action == "toggle_named_scratchpad") {
        n = split(args, a, ",")
        title = (n >= 2) ? trim(a[2]) : ""
        if (title == "" || title == "none") {
            split(trim(a[n]), a, " "); return "scratchpad: " basename(a[1])
        }
        return "scratchpad: " title
    }
    if (action == "view")       { split(args, a, ","); return "switch to tag "  trim(a[1]) }
    if (action == "toggleview") { split(args, a, ","); return "toggle tag "     trim(a[1]) }
    if (action == "tag")        { split(args, a, ","); return "move to tag "    trim(a[1]) }
    if (action == "tagsilent")  { return "send silent to tag " trim(args) }
    if (action == "tagmon")     { split(args, a, ","); return "to monitor "     trim(a[1]) }
    gsub(/_/, " ", action); return action
}

function combo(mods, key,   parts, n, i, out, p) {
    n = split(mods, parts, "+")
    out = ""
    for (i = 1; i <= n; i++) {
        p = toupper(trim(parts[i]))
        if (p == "NONE") continue
        out = out (out != "" ? "+" : "") p
    }
    return (out != "" ? out "+" : "") toupper(key)
}

BEGIN { section = "general" }

/^[ \t]*#/ && !/^[ \t]*#bind/ {
    line = $0
    gsub(/^[ \t]*#[ \t]*/, "", line)
    gsub(/^[-= ]+|[-= ]+$/, "", line)
    gsub(/[ \t]*\([^)]*\)/, "", line)
    line = trim(line)
    if (line != "" && line !~ /^[A-Z]+:/ && length(line) <= 50) section = line
    next
}

/^bind=/ {
    rest = substr($0, 6)
    n = split(rest, f, ",")
    mods   = trim(f[1])
    key    = trim(f[2])
    action = trim(f[3])
    args   = ""
    for (i = 4; i <= n; i++) {
        if (args != "") args = args ","
        args = args f[i]
    }
    printf "%-26s  %-30s  %s\n", combo(mods, key), label(action, args), section
}
' "$BINDS_FILE")"

[ -n "$entries" ] || exit 0

printf '%s\n' "$entries" | rofi -dmenu -i -p ' Keybinds:' \
    -theme "$ROFI_THEME" \
    -theme-str 'window { width: 60em; } listview { lines: 15; }' \
    -no-custom || true
