local wezterm = require("wezterm")

local is_windows = wezterm.target_triple:find("windows") ~= nil
local shell

if is_windows then
	shell = { "pwsh", "-NoLogo" }
else
	shell = { "zsh" }
end

return {
	-- Shell
	default_prog = shell,

	-- Font
	font = wezterm.font({
		family = "Iosevka Nerd Font",
		assume_emoji_presentation = false,
	}),
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

	-- Gruvbox Dark
	colors = {
		foreground = "#EBDBB2",
		background = "#282828",

		cursor_bg = "#EBDBB2",
		cursor_fg = "#282828",
		cursor_border = "#EBDBB2",

		selection_fg = "#EBDBB2",
		selection_bg = "#504945",

		scrollbar_thumb = "#665C54",
		split = "#665C54",

		ansi = {
			"#282828",
			"#CC241D",
			"#98971A",
			"#D79921",
			"#458588",
			"#B16286",
			"#689D6A",
			"#A89984",
		},

		brights = {
			"#928374",
			"#FB4934",
			"#B8BB26",
			"#FABD2F",
			"#83A598",
			"#D3869B",
			"#8EC07C",
			"#EBDBB2",
		},

		tab_bar = {
			background = "#282828",

			active_tab = {
				bg_color = "#83A598",
				fg_color = "#282828",
			},

			inactive_tab = {
				bg_color = "#3C3836",
				fg_color = "#EBDBB2",
			},

			inactive_tab_hover = {
				bg_color = "#504945",
				fg_color = "#EBDBB2",
			},

			new_tab = {
				bg_color = "#3C3836",
				fg_color = "#EBDBB2",
			},

			new_tab_hover = {
				bg_color = "#504945",
				fg_color = "#FABD2F",
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
