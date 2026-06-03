local wezterm = require("wezterm")

return {
  -- Shell
  default_prog = { "pwsh.exe", "-NoLogo" },

  -- Font
  font = wezterm.font("ZedMono Nerd Font"),
  font_size = 11.0,

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

  -- Tabs
  enable_tab_bar = true,
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,

  -- Scrolling
  scrollback_lines = 10000,
  mouse_wheel_scrolls_tabs = false,

  -- Mouse copy on select
  automatically_reload_config = true,
  selection_word_boundary = " \t\n{}[]()\"'`,;:",

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

    cursor_bg = "#FE8019",
    cursor_fg = "#282828",
    cursor_border = "#FE8019",

    selection_fg = "#282828",
    selection_bg = "#FABD2F",

    scrollbar_thumb = "#504945",
    split = "#504945",

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
        bg_color = "#D79921",
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
      key = "j",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "k",
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
  },
}