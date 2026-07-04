local wezterm = require("wezterm")

return {
	-- Font
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 11.0,
	font_rasterizer = "FreeType",
	freetype_load_target = "Normal",
	freetype_render_target = "Normal",
	line_height = 1.0,
	cell_width = 1.0,

	-- Cursor
	default_cursor_style = "SteadyBar",
	cursor_thickness = 1.5,

	-- Window
	initial_cols = 120,
	initial_rows = 32,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	window_decorations = "RESIZE",

	enable_wayland = false,

	-- Tabs
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,
	use_fancy_tab_bar = false,

	-- Scrolling
	scrollback_lines = 10000,
	mouse_wheel_scrolls_tabs = false,

	-- Confirm close
	window_close_confirmation = "NeverPrompt",

	-- Performance-ish
	animation_fps = 60,
	max_fps = 120,
	front_end = "WebGpu",

	-- Nord Dark
	colors = {
		foreground = "#D8DEE9",
		background = "#2E3440",

		cursor_bg = "#D8DEE9",
		cursor_fg = "#2E3440",
		cursor_border = "#D8DEE9",

		selection_fg = "#D8DEE9",
		selection_bg = "#4C566A",

		scrollbar_thumb = "#4C566A",
		split = "#4C566A",

		ansi = {
			"#3B4252",
			"#BF616A",
			"#A3BE8C",
			"#EBCB8B",
			"#81A1C1",
			"#B48EAD",
			"#88C0D0",
			"#E5E9F0",
		},

		brights = {
			"#4C566A",
			"#BF616A",
			"#A3BE8C",
			"#EBCB8B",
			"#81A1C1",
			"#B48EAD",
			"#8FBCBB",
			"#ECEFF4",
		},

		tab_bar = {
			background = "#2E3440",

			active_tab = {
				bg_color = "#88C0D0",
				fg_color = "#2E3440",
			},

			inactive_tab = {
				bg_color = "#3B4252",
				fg_color = "#D8DEE9",
			},

			inactive_tab_hover = {
				bg_color = "#4C566A",
				fg_color = "#D8DEE9",
			},

			new_tab = {
				bg_color = "#3B4252",
				fg_color = "#D8DEE9",
			},

			new_tab_hover = {
				bg_color = "#4C566A",
				fg_color = "#EBCB8B",
			},
		},
	},

	-- Keybinds
	keys = {
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = wezterm.action.CopyTo("Clipboard"),
		},
		{
			key = "v",
			mods = "CTRL|SHIFT",
			action = wezterm.action.PasteFrom("Clipboard"),
		},

		{
			key = "n",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},
		{
			key = "q",
			mods = "CTRL|SHIFT",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},

		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivateTabRelative(1),
		},

		-- Font zoom
		{
			key = "-",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "=",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "_",
			mods = "CTRL|SHIFT",
			action = wezterm.action.DecreaseFontSize,
		},
		{
			key = "=",
			mods = "CTRL|SHIFT",
			action = wezterm.action.IncreaseFontSize,
		},
	},
}
