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

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

naughty.config.padding = 15
naughty.config.spacing = 4
naughty.config.defaults.position = "top_right"
