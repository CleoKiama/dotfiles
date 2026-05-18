local terminal = "ghostty"
local fileManager = "nautilus"
local menu = os.getenv("HOME") .. "/.config/rofi/rofilaunch.sh"
local browser = "zen-browser"
local mainMod = "SUPER"

hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("DRI_PRIME=1 flatpak run io.freetubeapp.FreeTube"))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/scripts/cliphist.sh -c"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit"))

hl.bind("ALT + RETURN", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("grim -g \"$(slurp $SLURP_ARGS)\" - | wl-copy && notify-send \"Screenshot Captured\" \"Image copied to clipboard\" -i camera-photo"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("grim -g \"$(slurp $SLURP_ARGS)\" tmp.png && tesseract tmp.png - | wl-copy && rm tmp.png"), { locked = true })
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/record.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/record.sh"))

hl.bind(mainMod .. " + 1", hl.dsp.workspace(1))
hl.bind(mainMod .. " + 2", hl.dsp.workspace(2))
hl.bind(mainMod .. " + 3", hl.dsp.workspace(3))
hl.bind(mainMod .. " + 4", hl.dsp.workspace(4))
hl.bind(mainMod .. " + 5", hl.dsp.workspace(5))
hl.bind(mainMod .. " + 6", hl.dsp.workspace(6))
hl.bind(mainMod .. " + 7", hl.dsp.workspace(7))
hl.bind(mainMod .. " + 8", hl.dsp.workspace(8))
hl.bind(mainMod .. " + 9", hl.dsp.workspace(9))
hl.bind(mainMod .. " + 0", hl.dsp.workspace(10))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + ALT + 1", hl.dsp.window.move({ workspace = "1 silent" }))
hl.bind(mainMod .. " + ALT + 2", hl.dsp.window.move({ workspace = "2 silent" }))
hl.bind(mainMod .. " + ALT + 3", hl.dsp.window.move({ workspace = "3 silent" }))
hl.bind(mainMod .. " + ALT + 4", hl.dsp.window.move({ workspace = "4 silent" }))
hl.bind(mainMod .. " + ALT + 5", hl.dsp.window.move({ workspace = "5 silent" }))
hl.bind(mainMod .. " + ALT + 6", hl.dsp.window.move({ workspace = "6 silent" }))
hl.bind(mainMod .. " + ALT + 7", hl.dsp.window.move({ workspace = "7 silent" }))
hl.bind(mainMod .. " + ALT + 8", hl.dsp.window.move({ workspace = "8 silent" }))
hl.bind(mainMod .. " + ALT + 9", hl.dsp.window.move({ workspace = "9 silent" }))
hl.bind(mainMod .. " + ALT + 0", hl.dsp.window.move({ workspace = "10 silent" }))

hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/waybar/launch.sh"))

hl.bind(mainMod .. " + mouse_down", hl.dsp.workspace("e+1"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.workspace("e-1"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("hyprctl hyprsunset temperature 5500"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("hyprctl hyprsunset identity"))

hl.bind("ALT + F4", hl.dsp.exec_cmd("wlogout"))

hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd(os.getenv("HOME") .. "/dotfiles/scripts/emoji_picker.sh"))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort"))

hl.bind(mainMod .. " + SPACE", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + J", hl.dsp.layout("focus d"))
hl.bind(mainMod .. " + K", hl.dsp.layout("focus u"))

hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("movewindowto d"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.layout("movewindowto u"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("movewindowto l"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.layout("movewindowto r"))

hl.bind(mainMod .. " + CTRL + 1", hl.dsp.layout("movecoltoworkspace 1"))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.layout("movecoltoworkspace 2"))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.layout("movecoltoworkspace 3"))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.layout("movecoltoworkspace 4"))
hl.bind(mainMod .. " + CTRL + 5", hl.dsp.layout("movecoltoworkspace 5"))
hl.bind(mainMod .. " + CTRL + 6", hl.dsp.layout("movecoltoworkspace 6"))
hl.bind(mainMod .. " + CTRL + 7", hl.dsp.layout("movecoltoworkspace 7"))
hl.bind(mainMod .. " + CTRL + 8", hl.dsp.layout("movecoltoworkspace 8"))
hl.bind(mainMod .. " + CTRL + 9", hl.dsp.layout("movecoltoworkspace 9"))
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.layout("movecoltoworkspace 10"))

hl.bind(mainMod .. " + EQUAL", hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + MINUS", hl.dsp.layout("colresize -conf"))

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximize", action = "set" }))

hl.bind(mainMod .. " + ALT + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.layout("swapcol r"))