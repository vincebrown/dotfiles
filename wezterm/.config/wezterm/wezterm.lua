local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true

config.font_size = 16
config.line_height = 1.5

config.color_scheme = "Edge Dark (base16)"
config.freetype_load_flags = "NO_AUTOHINT"

config.font = wezterm.font("Berkeley Mono")
config.use_cap_height_to_scale_fallback_fonts = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10
config.window_padding = {
	bottom = 0,
	top = 12,
	left = 12,
	right = 12,
}

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.colors = {
	-- background = "#0f0f0f",
	tab_bar = {
		background = "#000000", -- base00
		active_tab = {
			bg_color = "#222222", -- base02
			fg_color = "#c1c1c1", -- base05
		},
		inactive_tab = {
			bg_color = "#121212", -- base01
			fg_color = "#999999", -- base04
		},
		new_tab = {
			bg_color = "#121212", -- base01
			fg_color = "#999999", -- base04
		},
	},
}

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

config.keys = {
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action({ SendString = "\x1b\r" }),
	},
	{
		key = "D",
		mods = "CMD",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "h",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "y",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SwitchToWorkspace({
			name = "default",
		}),
	},
	{
		key = "9",
		mods = "ALT",
		action = wezterm.action.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "W",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}

-- config.leader = { key = "SUPER", timeout_milliseconds = 1000 }

return config
