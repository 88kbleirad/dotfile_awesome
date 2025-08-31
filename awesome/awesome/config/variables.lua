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

local vars = {}

vars.terminal = "alacritty"
vars.editor = os.getenv("EDITOR") or "nvim"
vars.editor_cmd = vars.terminal .. " -e " .. vars.editor
vars.modkey = "Mod1"

return vars
