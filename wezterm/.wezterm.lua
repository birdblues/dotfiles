-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.term = "wezterm"

config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font_with_fallback({
	{
		family = "JetBrains Mono",
		weight = "ExtraLight",
		harfbuzz_features = {
			"ss01=1",
			"ss02=1",
		},
	},
	{ family = "Pretendard GOV", weight = "Light" },
	{ family = "Apple Color Emoji" },
})

config.font_rules = {
	-- Bold만
	{
		intensity = "Bold",
		font = wezterm.font_with_fallback({
			{ family = "JetBrains Mono", weight = "Bold" },
			{ family = "Pretendard GOV", weight = "Bold" },
		}),
	},
	-- Italic만
	{
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "JetBrains Mono", style = "Italic" },
			{ family = "Pretendard GOV", style = "Italic" },
		}),
	},
	-- Bold + Italic
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "JetBrains Mono", weight = "Bold", style = "Italic" },
			{ family = "Pretendard GOV", weight = "Bold", style = "Italic" },
		}),
	},
}

config.color_scheme = "Tokyo Night Moon"
config.font_size = 16
config.line_height = 1.10
config.enable_kitty_graphics = true
config.max_fps = 120

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.enable_scroll_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20
config.window_close_confirmation = "NeverPrompt"

config.leader = { key = "F", mods = "CTRL|SHIFT|ALT", timeout_milliseconds = 1500 }
config.keys = {
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = " ", mods = "LEADER", action = wezterm.action.PaneSelect({ alphabet = "1234567890" }) },
}

return config
