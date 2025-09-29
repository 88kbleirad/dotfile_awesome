local theme = {}

theme.useless_gap = 7
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

theme.font = "JetBrainsMono Nerd Font 14"

-- Màu nền & chữ
theme.bg_normal = "#222222"
theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"

-- Border & titlebar
theme.border_width = dpi(2)
theme.border_normal = "#363a4f"
theme.border_focus = "#1e1e2e"
theme.border_marked = "#91231c"
theme.titlebar_bg_normal = "#1e1e2e"
theme.titlebar_bg_focus = "#1e1e2e"

-- Systray
theme.systray_icon_spacing = 10
theme.systray_icon_size = 10
theme.bg_systray = "#1e1e2e"

-- Layout icons
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

return theme
