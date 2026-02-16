-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font_with_fallback({
	{
		family = "JetBrainsMono Nerd Font Mono",
		weight = "Regular",
	},
	-- You can add more fallbacks if needed
})

config.font_size = 12.0

config.enable_tab_bar = false

config.default_prog = { "wsl.exe", "--cd", "~" }

wezterm.on("gui-startup", function(cmd)
	local active_screen = wezterm.gui.screens().active
	local _, _, window = wezterm.mux.spawn_window(cmd or {})

	if window then
		window:gui_window():maximize()
	end
end)

return config
