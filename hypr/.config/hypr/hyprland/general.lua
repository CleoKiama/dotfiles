hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 6,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "scrolling",
	},
})

hl.config({
	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.9,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 4,
			color = 0x4d000000,
			ignore_window = false,
		},
		blur = {
			enabled = true,
			size = 1,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
})

hl.config({
	cursor = {
		inactive_timeout = 3,
		hide_on_key_press = true,
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
})

hl.config({
	animations = {
		enabled = true,
	},
})

hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } })
hl.curve("crazyshot", { type = "bezier", points = { { 0.1, 1.5 }, { 0.76, 0.92 } } })
hl.curve("hyprnostretch", { type = "bezier", points = { { 1.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.38, 0.04 }, { 1, 0.07 } } })
hl.curve("easeInOutCirc", { type = "bezier", points = { { 0.85, 0 }, { 0.15, 1 } } })
hl.curve("easeOutCirc", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("softAcDecel", { type = "bezier", points = { { 0.26, 0.26 }, { 0.15, 1 } } })
hl.curve("md2", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 1, curve = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1, curve = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, curve = "md3_accel", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 1, curve = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, curve = "md3_decel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1, curve = "menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, curve = "menu_accel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1, curve = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, curve = "menu_accel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, curve = "menu_decel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1, curve = "md3_decel", style = "slidevert" })

hl.config({
	dwindle = {
		pseudotile = true,
		preserve_split = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	scrolling = {
		direction = "right",
		column_width = 0.5,
		fullscreen_on_one_column = true,
		follow_focus = true,
	},
})

hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "right",
	action = "dispatch",
	dispatcher = "layoutmsg",
	params = "focus l",
})

hl.gesture({
	fingers = 3,
	direction = "left",
	action = "dispatch",
	dispatcher = "layoutmsg",
	params = "focus r",
})

hl.monitor("eDP-1", "1920x1080@60.01000", "0x0", 1.25)
hl.monitor("DP-4", "3440x1440@60", "1536x0", 1)

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "ctrl:nocaps",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

