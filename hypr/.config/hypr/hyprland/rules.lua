hl.window_rule({
    name = "Floating window apps",
    match = { class = "blueberry\\.py" },
    float = true,
})

hl.window_rule({
    name = "Floating window apps",
    match = { class = "org\\.pulseaudio\\.pavucontrol" },
    float = true,
})

hl.window_rule({
    name = "Floating window apps",
    match = { class = "com\\.network\\.manager" },
    float = true,
})

hl.window_rule({
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    tag = "+picture-in-picture",
})

hl.window_rule({
    match = { tag = "picture-in-picture" },
    float = true,
})

hl.window_rule({
    match = { tag = "picture-in-picture" },
    keep_aspect_ratio = false,
})

hl.window_rule({
    match = { tag = "picture-in-picture" },
    move = { "90%", "90%" },
})

hl.window_rule({
    match = { tag = "picture-in-picture" },
    size = { "10%", "10%" },
})

hl.window_rule({
    match = { tag = "picture-in-picture" },
    pin = true,
})

hl.window_rule({ match = { title = "^Open File$" }, float = true })
hl.window_rule({ match = { title = "^Select a File$" }, float = true })
hl.window_rule({ match = { title = "^Open Folder$" }, float = true })
hl.window_rule({ match = { title = "^Save As$" }, float = true })
hl.window_rule({ match = { title = "^Library$" }, float = true })
hl.window_rule({ match = { title = "^File Upload$" }, float = true })

hl.window_rule({ match = { title = "^Open File$" }, size = { "60%", "70%" } })
hl.window_rule({ match = { title = "^Select a File$" }, size = { "60%", "70%" } })
hl.window_rule({ match = { title = "^Open Folder$" }, size = { "60%", "70%" } })
hl.window_rule({ match = { title = "^Save As$" }, size = { "60%", "70%" } })
hl.window_rule({ match = { title = "^Library$" }, size = { "60%", "70%" } })
hl.window_rule({ match = { title = "^File Upload$" }, size = { "60%", "70%" } })
hl.window_rule({ match = { title = "^Bluetooth$" }, size = { "80%", "60%" } })

hl.window_rule({
    match = { fullscreen = true, class = "mpv" },
    idle_inhibit = "always",
})

hl.window_rule({
    match = { fullscreen = true, class = "vlc" },
    idle_inhibit = "always",
})

hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0, xray = true })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true, xray = true })

hl.window_rule({ match = { class = "google-chrome" }, workspace = "1" })
hl.window_rule({ match = { class = "zen" }, workspace = "1" })
hl.window_rule({ match = { class = "Chromium" }, workspace = "1" })
hl.window_rule({ match = { class = "Code" }, workspace = "2" })
hl.window_rule({ match = { class = "md.obsidian.Obsidian" }, workspace = "3" })
hl.window_rule({ match = { class = "com.github.th_ch.youtube_music" }, workspace = "3" })
hl.window_rule({ match = { class = "mpv" }, workspace = "3" })
hl.window_rule({ match = { class = "vlc" }, workspace = "3" })
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, workspace = "4" })
hl.window_rule({
    match = { class = "com.mitchellh.ghostty" },
    workspace = "2",
    no_blur = true,
})