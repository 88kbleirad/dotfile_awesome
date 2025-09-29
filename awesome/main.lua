pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

local vars = require("config.variables")
terminal = vars.terminal
editor = vars.editor
editor_cmd = vars.editor_cmd
modkey = vars.modkey

--Menu for terminal
menubar.utils.terminal = terminal

--Menu for launcher
require("config.menu")

-- Wdiget
require("config.widgets")

--Taglist / Tasklist buttons
require("config.buttons")

--Wallpaper + wibar + screen setup
require("config.screen")

--Config layout
require("config.layouts")

--Create theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme/init.lua")

--Autostart app
require("autostart.apps")

-- Sort keybinding
require("config.keys")
require("config.mouse")

-- Config tags (workspace)
require("config.tags")

--Rules window
require("config.rules")

--Hooks / Signals
require("config.signals")

--Autorun scripts
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
