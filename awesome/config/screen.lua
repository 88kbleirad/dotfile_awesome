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

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget({
	format = " %A %d/%m/%y %H:%M",
	font = "JetBrainsMono Nerd Font 11",
	align = "center",
	widget = wibox.widget.textclock,
})

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

--Battery icon right
local battery_widget = require("widgets.battery")
--Bluelight icon right
local bluelight_widget = require("widgets.bluelight.init")
--Brightness icon right
local brightness_widget = require("widgets.brightness")
--Cpu icon right
local cpu_widget = require("widgets.cpu-widget.cpu-widget")
--Filesystem icon right
local fs_widget = require("widgets.fs-widget")
--Github contribution icon right
local git_c_widget = require("widgets.github-contributions-widget.github-contributions-widget")
local logout_popup = require("widgets.logout-popup-widget.logout-popup")
local net_speed_widget = require("widgets.net-speed-widget.net-speed")
local volume_widget = require("widgets.volume-widget.volume")

-- Firefox icon
local firefox_icon = wibox.widget({
	image = "/usr/share/icons/hicolor/48x48/apps/firefox.png",
	resize = true,
	widget = wibox.widget.imagebox,
})

local firefox_button = wibox.widget({
	{
		firefox_icon,
		margins = 4,
		widget = wibox.container.margin,
	},
	bg = "#85c1dc",
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

-- Gắn chức năng click
firefox_button:connect_signal("button::press", function()
	awful.spawn("firefox")
end)

local thunar_button = wibox.widget({
	{
		{
			image = "/usr/share/icons/hicolor/48x48/apps/org.xfce.thunar.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	bg = "#85c1dc",
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

thunar_button:connect_signal("button::press", function()
	awful.spawn("thunar")
end)
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

	s.padding = {
		top = 5,
		bottom = 5,
		left = 5,
		right = 5,
	}

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		width = 1860,
		height = 40,
		bg = "#1e1e2e",
		fg = "#cdd6f4",
		border_width = 2,
		border_color = "#89b4fa",
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 15)
		end,
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			s.mytaglist,
			{
				firefox_button,
				margins = 5,
				widget = wibox.container.margin,
			},
			{
				thunar_button,
				margins = 5,
				widget = wibox.container.margin,
			},
			s.mypromptbox,
			s.mytasklist,
		},
		-- Middle widget
		{
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 6,
				-- Clock block
				{
					{
						{
							layout = wibox.layout.fixed.horizontal,
							mytextclock,
						},
						bg = "#7dc4e4",
						fg = "#000000",
						forced_width = 220,
						forced_height = 30,
						shape = gears.shape.rounded_rect,
						widget = wibox.container.background,
					},
					margins = 1,
					widget = wibox.container.margin,
				},

				-- Layoutbox block
				{
					{
						{
							layout = wibox.layout.fixed.horizontal,
							s.mylayoutbox,
						},
						bg = "#7dc4e4",
						fg = "#000000",
						forced_width = 30,
						forced_height = 30,
						shape = gears.shape.rounded_rect,
						widget = wibox.container.background,
					},
					margins = 1,
					widget = wibox.container.margin,
				},
			},
			halign = "center",
			valign = "center",
			widget = wibox.container.place,
		},

		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),

			{
				{
					{
						mykeyboardlayout,
						margins = 4, -- khoảng cách bên trong
						widget = wibox.container.margin,
					},
					bg = "#b7bdf8",
					fg = "#181926",
					forced_width = 30,
					forced_height = 30,
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			wibox.widget.textbox(" "),
			{
				{
					{
						volume_widget({
							widget_type = "arc",
						}),
						margin = 4,
						widget = wibox.container.margin,
					},
					bg = "#8caaee",
					fg = "#181926",
					forced_width = 30,
					forced_height = 30,
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			wibox.widget.textbox(" "),
			{
				{

					{
						cpu_widget({
							width = 70,
							step_width = 2,
							step_spacing = 0,
							color = "#181926",
						}),
						margin = 4,
						widget = wibox.container.margin,
					},
					bg = "#81c8be",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			wibox.widget.textbox(" "),
			{
				{
					{
						fs_widget(),
						margin = 4,
						widget = wibox.container.margin,
					},

					bg = "#99d1db",
					fg = "#ffffff",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			wibox.widget.textbox("   "),
			--git_c_widget({ username = "lephong88" }),
			{
				{
					{
						net_speed_widget(),
						margin = 4,
						widget = wibox.container.margin,
					},

					bg = "#8aadf4",
					fg = "#ffffff",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			{
				{
					{
						battery_widget(),
						margin = 4,
						widget = wibox.container.margin,
					},

					bg = "#8aadf4",
					fg = "#f5e0dc",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			{
				{
					{
						logout_popup.widget({}),
						margin = 4,
						widget = wibox.container.margin,
					},

					bg = "#91d7e3",
					fg = "#ffffff",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
		},
	})
	for _, t in pairs(s.tags) do
		t.layout = awful.layout.suit.spiral
	end
end)
-- }}}
