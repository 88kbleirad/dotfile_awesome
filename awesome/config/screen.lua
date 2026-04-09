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
	font = "MapleMono NF CN 10",
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

-- local function set_wallpaper(s)
-- 	-- Wallpaper
-- 	if beautiful.wallpaper then
-- 		local wallpaper = beautiful.wallpaper
-- 		-- If wallpaper is a function, call it with the screen
-- 		if type(wallpaper) == "function" then
-- 			wallpaper = wallpaper(s)
-- 		end
-- 		gears.wallpaper.maximized(wallpaper, s, true)
-- 	end
-- end
--

local function set_wallpaper(s)
	local wp = "/home/dariel/Pictures/Personal_Edited.jpg"
	gears.wallpaper.maximized(wp, s, true)
end

-- Đổi lại khi thêm / bớt màn hình
screen.connect_signal("added", function(s)
	set_wallpaper(s)
end)
screen.connect_signal("removed", function(s)
	if screen[1] then
		set_wallpaper(screen[1])
	end
end)

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
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

thunar_button:connect_signal("button::press", function()
	awful.spawn("thunar")
end)

local obsidian_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/icons8-obsidian-48.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

obsidian_button:connect_signal("button::press", function()
	awful.spawn("/hme/dariel/Applications/Obsidian-1.9.12.AppImage")
end)

local libreoffice_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/libreoffice.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

libreoffice_button:connect_signal("button::press", function()
	awful.spawn("libreoffice")
end)

-- local intellij_button = wibox.widget({
-- 	{
-- 		{
-- 			image = "/home/dariel/.icons/intellij-idea.png",
-- 			resize = true,
-- 			widget = wibox.widget.imagebox,
-- 		},
-- 		margins = 7,
-- 		widget = wibox.container.margin,
-- 	},
-- 	bg = "#1e1e2e",
-- 	forced_width = 30,
-- 	forced_height = 30,
-- 	shape = gears.shape.rounded_rect,
-- 	widget = wibox.container.background,
-- })
--
-- intellij_button:connect_signal("button::press", function()
-- 	awful.spawn("intellij-idea-community")
-- end)

local protonvpn_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/protonvpn.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

protonvpn_button:connect_signal("button::press", function()
	awful.spawn("protonvpn-app")
end)

local packettracer_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/packettracer.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

packettracer_button:connect_signal("button::press", function()
	awful.spawn("packettracer")
end)

local anki_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/anki.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

anki_button:connect_signal("button::press", function()
	awful.spawn("/home/dariel/anki-launcher-25.09-linux/anki")
end)

local wireshark_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/wireshark.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

wireshark_button:connect_signal("button::press", function()
	awful.spawn("wireshark")
end)

local discord_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/discord2.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

discord_button:connect_signal("button::press", function()
	awful.spawn("legcord")
end)

-- local vscode_button = wibox.widget({
-- 	{
-- 		{
-- 			image = "/home/dariel/.icons/vscode.png",
-- 			resize = true,
-- 			widget = wibox.widget.imagebox,
-- 		},
-- 		margins = 7,
-- 		widget = wibox.container.margin,
-- 	},
-- 	bg = "#1e1e2e",
-- 	forced_width = 30,
-- 	forced_height = 30,
-- 	shape = gears.shape.rounded_rect,
-- 	widget = wibox.container.background,
-- })
--
-- vscode_button:connect_signal("button::press", function()
-- 	awful.spawn("code")
-- end)

local truykich_button = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/BattleStrike.png",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

truykich_button:connect_signal("button::press", function()
	awful.spawn.with_shell([[
        cd '/home/dariel/.wine/drive_c/Program Files (x86)/VTCMobile/TruyKich/' &&
        env \
        GTK_IM_MODULE=none \
        QT_IM_MODULE=none \
        XMODIFIERS="@im=none" \
        WINEDEBUG=-all \
        STAGING_SHARED_MEMORY=1 \
        DXVK_ASYNC=1 \
        __GL_THREADED_OPTIMIZATIONS=1 \
        MESA_GLTHREAD=true \
        DXVK_HUD=0 \
        vblank_mode=0 \
        nice -n -10 \
        gamemoderun \
        wine WDlauncher.exe
    ]])
end)

-- local virtualbox_button = wibox.widget({
-- 	{
-- 		{
-- 			image = "/home/dariel/.icons/virtualbox.png",
-- 			resize = true,
-- 			widget = wibox.widget.imagebox,
-- 		},
-- 		margins = 4,
-- 		widget = wibox.container.margin,
-- 	},
-- 	bg = "#8caaee",
-- 	forced_width = 30,
-- 	forced_height = 30,
-- 	shape = gears.shape.rounded_rect,
-- 	widget = wibox.container.background,
-- })
--
-- virtualbox_button:connect_signal("button::press", function()
-- 	awful.spawn("virtualbox")
-- end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local my_text_btn = wibox.widget({
	{
		{
			image = "/home/dariel/.icons/awesomeWM.png",
			resize = true,
			widget = wibox.widget.imagebox,
			bg = "#cdd6e4",
		},
		margins = 4,
		widget = wibox.container.margin,
	},
	forced_width = 30,
	forced_height = 30,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})
beautiful.menu_font = "Maple Mono NF CN 14"
beautiful.menu_height = 64
beautiful.menu_width = 360
beautiful.menu_bg_focus = "#cdd6e4"
beautiful.menu_fg_normal = "#cdd6e4"
beautiful.menu_fg_focus = "#1e1e2e"
beautiful.menu_bg_normal = "#1e1e2e"
-- Menu dropdown
local gap = utf8.char(0x2002) .. utf8.char(0x2002)
local app_menu = awful.menu({
	items = {
		{
			gap .. "Firefox",
			function()
				awful.spawn("firefox")
			end,
			"/usr/share/icons/hicolor/48x48/apps/firefox.png",
		},
		{
			gap .. "Thunar",
			function()
				awful.spawn("thunar")
			end,
			"/usr/share/icons/hicolor/48x48/apps/org.xfce.thunar.png",
		},
		{
			gap .. "Obsidian",
			function()
				awful.spawn("/home/dariel/Applications/Obsidian-1.9.12.AppImage")
			end,
			"/home/dariel/.icons/icons8-obsidian-48.png",
		},
		{
			gap .. "Libreoffice",
			function()
				awful.spawn("libreoffice")
			end,
			"/home/dariel/.icons/libreoffice.png",
		},
		{
			gap .. "Discord",
			function()
				awful.spawn("legcord")
			end,
			"/home/dariel/.icons/discord2.png",
		},
		{
			gap .. "Proton VPN",
			function()
				awful.spawn("protonvpn-app")
			end,
			"/home/dariel/.icons/protonvpn.png",
		},
		{
			gap .. "Cisco Packet Tracer",
			function()
				awful.spawn("packettracer")
			end,
			"/home/dariel/.icons/packettracer.png",
		},

		{
			gap .. "GNS3",
			function()
				awful.spawn.with_shell(
					"zsh -lc 'source ~/.venvs/gns3-311/bin/activate && nohup gns3server >/tmp/gns3server.log 2>&1 &'"
				)
				awful.spawn.with_shell("zsh -lc 'source ~/.venvs/gns3-311/bin/activate && gns3'")
			end,
			"/home/dariel/.icons/gns3.png",
		},
		{
			gap .. "Virtual Manager",
			function()
				awful.spawn.with_shell("virt-manager")
			end,
			"/home/dariel/.icons/qemu.png",
		},
		{
			gap .. "Anki",
			function()
				awful.spawn("/home/dariel/anki-launcher-25.09-linux/anki")
			end,
			"/home/dariel/.icons/anki.png",
		},
		{
			gap .. "Wireshark",
			function()
				awful.spawn("wireshark")
			end,
			"/home/dariel/.icons/wireshark.png",
		},
	},
})

-- Click vào text để toggle menu
my_text_btn:buttons(gears.table.join(awful.button({}, 1, function()
	app_menu:toggle({ coords = { x = 15, y = 55 } })
end)))

local mouse = mouse
local function edge_poll_time(s, bar, pos)
	pos = pos or "top"
	local threehold = 35
	bar.visible = false
	bar.ontop = true

	local t = gears.timer({ timeout = 0.05 })
	t:connect_signal("timeout", function()
		local c = mouse.coords()
		local g = s.geometry

		local inside_screen = (c.x >= g.x and c.x < g.x + g.width and c.y >= g.y and c.y < g.y + g.height)
		if not inside_screen then
			if bar.visible then
				bar.visible = false
			end
			return
		end

		local near = false
		if pos == "top" then
			near = (c.y <= g.y + threehold)
		elseif pos == "bottom" then
			near = (c.y >= g.y + g.height - threehold)
		elseif pos == "left" then
			near = (c.x <= g.x + threehold)
		elseif pos == "right" then
			near = (c.x >= g.x + g.width - threehold)
		end

		if near then
			if not bar.visible then
				bar.visible = true
			end
		else
			if bar.visible then
				bar.visible = false
			end
		end
	end)

	t:start()
end

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

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
	-- -- Create a taglist widget
	-- s.mytaglist = awful.widget.taglist({
	-- 	screen = s,
	-- 	filter = awful.widget.taglist.filter.all,
	-- 	buttons = taglist_buttons,
	-- })
	--
	-- -- Create a tasklist widget
	-- s.mytasklist = awful.widget.tasklist({
	-- 	screen = s,
	-- 	filter = awful.widget.tasklist.filter.currenttags,
	-- 	buttons = tasklist_buttons,
	-- 	layout = {
	-- 		layout = wibox.layout.fixed.horizontal,
	-- 	},
	-- 	widget_template = {
	-- 		{
	-- 			{
	-- 				id = "text_role",
	-- 				widget = wibox.widget.textbox,
	-- 			},
	-- 			margins = 7,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		widget = wibox.container.background,
	-- 		shape = gears.shape.rounded_rect,
	-- 		bg = "#1e1e2e",
	-- 		fg = "#cdd6f4",
	-- 		forced_width = 300,
	-- 	},
	-- })
	--
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		widget_template = {
			{
				{
					id = "clienticon",
					widget = awful.widget.clienticon,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			nil,
			create_callback = function(self, c, index, objects) --luacheck: no unused args
				self:get_children_by_id("clienticon")[1].client = c
			end,
			layout = wibox.layout.align.vertical,
		},
	})

	-- Create the wibox
	-- s.mywibox = awful.wibar({
	-- 	position = "top",
	-- 	screen = s,
	-- 	width = 1860,
	-- 	height = 40,
	-- 	bg = "#1e1e2e",
	-- 	fg = "#cdd6f4",
	-- 	border_width = 2,
	-- 	border_color = "#89b4fa",
	-- 	shape = function(cr, width, height)
	-- 		gears.shape.rounded_rect(cr, width, height, 15)
	-- 	end,
	-- })
	--

	--[[ 	if s.index == 1 then ]]
	--[[ 	Tạo wibar cho laptop ]]
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		width = 1900,
		height = 40,
		bg = "#1e1e2e",
		fg = "#cdd6f4",
		ontop = false,
		--[[ 	type = "dock", ]]
		border_width = 2,
		stretch = false,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 15)
		end,
	})
	awful.placement.top(s.mywibox, { margins = { top = 7 } })
	--[[ 	awful.screen.padding(s, { top = 2 }) ]]
	--
	edge_poll_time(s, s.mywibox, "top")

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			--[[ 	s.mytaglist, ]]
			{
				{
					my_text_btn,
					bg = "#cdd6e4",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			s.mytasklist,
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
						bg = "#cdd6f4",
						fg = "#1e1e2e",
						forced_width = 200,
						forced_height = 25,
						shape = gears.shape.rounded_rect,
						widget = wibox.container.background,
					},
					margins = 7,
					widget = wibox.container.margin,
				},
				-- Layoutbox block
				{
					{
						{
							layout = wibox.layout.fixed.horizontal,
							s.mylayoutbox,
						},
						bg = "#1e1e2e",
						forced_width = 30,
						forced_height = 20,
						shape = gears.shape.rounded_rect,
						widget = wibox.container.background,
					},
					margins = 7,
					widget = wibox.container.margin,
				},
			},

			-- {
			-- 	{
			--
			-- 		{
			-- 			layout = wibox.layout.fixed.horizontal,
			-- 			firefox_button,
			-- 			thunar_button,
			-- 			obsidian_button,
			-- 			libreoffice_button,
			-- 			discord_button,
			-- 			protonvpn_button,
			-- 			packettracer_button,
			-- 			anki_button,
			-- 			wireshark_button,
			-- 			truykich_button,
			-- 			margin = 2,
			-- 			widget = wibox.container.margin,
			-- 		},
			-- 		bg = "#cdd6e4",
			-- 		shape = gears.shape.rounded_rect,
			-- 		widget = wibox.container.background,
			-- 	},
			-- 	margins = 7,
			-- 	widget = wibox.container.margin,
			-- },
			s.mypromptbox,
		},
		-- Middle widgets (sẽ luôn ở giữa)
		{
			widget = wibox.container.place, -- Bọc trong place container
			halign = "center",
			valign = "center",
		},

		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			{
				{
					{
						wibox.widget.systray(),
						strategy = "exact", -- không scale icons
						margins = 6,
						widget = wibox.container.margin,
					},
					forced_height = 42,
					bg = "#1e1e2e",
					shape = function(cr, w, h)
						gears.shape.rounded_rect(cr, w, h, 10)
					end,
					widget = wibox.container.background,
				},
				margins = 2,
				widget = wibox.container.margin,
			},
			{
				{
					{
						volume_widget({
							widget_type = "arc",
						}),
						margin = 5,
						widget = wibox.container.margin,
					},
					bg = "#cdd6f4",
					fg = "#1e1e2e",
					forced_width = 25,
					forced_height = 25,
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 7,
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
							color = "#cdd6f4",
						}),
						margin = 4,
						widget = wibox.container.margin,
					},
					bg = "#1e1e2e",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 7,
				widget = wibox.container.margin,
			},
			wibox.widget.textbox(" "),
			{
				{
					{
						fs_widget(),
						margin = 3,
						widget = wibox.container.margin,
					},

					bg = "#cdd6f4",
					fg = "#1e1e2e",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 7,
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

					bg = "#cdd6f4",
					fg = "#1e1e2e",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 7,
				widget = wibox.container.margin,
			},
			{
				{
					{
						battery_widget(),
						margin = 4,
						widget = wibox.container.margin,
					},

					bg = "#1e1e2e",
					fg = "#ffffff",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 7,
				widget = wibox.container.margin,
			},
			{
				{
					{
						logout_popup.widget({}),
						margin = 4,
						widget = wibox.container.margin,
					},

					bg = "#cdd6f4",
					fg = "#1e1e2e",
					shape = gears.shape.rounded_rect,
					widget = wibox.container.background,
				},
				margins = 7,
				widget = wibox.container.margin,
			},
		},
	})
	-- else
	-- 	if s.mywibox then
	-- 		s.mywibox.visible = false
	-- 	end
	-- end

	-- Add widgets to the wibox
	-- s.mywibox:setup({
	-- 	layout = wibox.layout.align.horizontal,
	-- 	{ -- Left widgets
	-- 		layout = wibox.layout.fixed.horizontal,
	-- 		mylauncher,
	-- 		s.mytaglist,
	-- 		{
	-- 			firefox_button,
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		{
	-- 			thunar_button,
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		{
	-- 			obsidian_button,
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		s.mypromptbox,
	-- 		s.mytasklist,
	-- 	},
	-- 	-- Middle widget
	-- 	{
	-- 		{
	-- 			layout = wibox.layout.fixed.horizontal,
	-- 			spacing = 6,
	-- 			-- Clock block
	-- 			{
	-- 				{
	-- 					{
	-- 						layout = wibox.layout.fixed.horizontal,
	-- 						mytextclock,
	-- 					},
	-- 					bg = "#8caaee",
	-- 					fg = "#ffffff",
	-- 					forced_width = 235,
	-- 					forced_height = 30,
	-- 					shape = gears.shape.rounded_rect,
	-- 					widget = wibox.container.background,
	-- 				},
	-- 				margins = 1,
	-- 				widget = wibox.container.margin,
	-- 			},
	--
	-- 			-- Layoutbox block
	-- 			{
	-- 				{
	-- 					{
	-- 						layout = wibox.layout.fixed.horizontal,
	-- 						s.mylayoutbox,
	-- 					},
	-- 					bg = "#8caaee",
	-- 					fg = "#ffffff",
	-- 					forced_width = 30,
	-- 					forced_height = 30,
	-- 					shape = gears.shape.rounded_rect,
	-- 					widget = wibox.container.background,
	-- 				},
	-- 				margins = 1,
	-- 				widget = wibox.container.margin,
	-- 			},
	-- 		},
	-- 		halign = "center",
	-- 		valign = "center",
	-- 		widget = wibox.container.place,
	-- 	},
	--
	-- 	{ -- Right widgets
	-- 		layout = wibox.layout.fixed.horizontal,
	-- 		wibox.widget.systray(),
	-- 		{
	-- 			{
	-- 				{
	-- 					volume_widget({
	-- 						widget_type = "arc",
	-- 					}),
	-- 					margin = 4,
	-- 					widget = wibox.container.margin,
	-- 				},
	-- 				bg = "#8caaee",
	-- 				fg = "#181926",
	-- 				forced_width = 30,
	-- 				forced_height = 30,
	-- 				shape = gears.shape.rounded_rect,
	-- 				widget = wibox.container.background,
	-- 			},
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		wibox.widget.textbox(" "),
	-- 		{
	-- 			{
	--
	-- 				{
	-- 					cpu_widget({
	-- 						width = 70,
	-- 						step_width = 2,
	-- 						step_spacing = 0,
	-- 						color = "#ffffff",
	-- 					}),
	-- 					margin = 4,
	-- 					widget = wibox.container.margin,
	-- 				},
	-- 				bg = "#8caaee",
	-- 				shape = gears.shape.rounded_rect,
	-- 				widget = wibox.container.background,
	-- 			},
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		wibox.widget.textbox(" "),
	-- 		{
	-- 			{
	-- 				{
	-- 					fs_widget(),
	-- 					margin = 4,
	-- 					widget = wibox.container.margin,
	-- 				},
	--
	-- 				bg = "#8caaee",
	-- 				fg = "#ffffff",
	-- 				shape = gears.shape.rounded_rect,
	-- 				widget = wibox.container.background,
	-- 			},
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		wibox.widget.textbox("   "),
	-- 		--git_c_widget({ username = "lephong88" }),
	-- 		{
	-- 			{
	-- 				{
	-- 					net_speed_widget(),
	-- 					margin = 4,
	-- 					widget = wibox.container.margin,
	-- 				},
	--
	-- 				bg = "#8aadf4",
	-- 				fg = "#f5e0dc",
	-- 				shape = gears.shape.rounded_rect,
	-- 				widget = wibox.container.background,
	-- 			},
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		{
	-- 			{
	-- 				{
	-- 					battery_widget(),
	-- 					margin = 4,
	-- 					widget = wibox.container.margin,
	-- 				},
	--
	-- 				bg = "#8aadf4",
	-- 				fg = "#f5e0dc",
	-- 				shape = gears.shape.rounded_rect,
	-- 				widget = wibox.container.background,
	-- 			},
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 		{
	-- 			{
	-- 				{
	-- 					logout_popup.widget({}),
	-- 					margin = 4,
	-- 					widget = wibox.container.margin,
	-- 				},
	--
	-- 				bg = "#8caaee",
	-- 				fg = "#ffffff",
	-- 				shape = gears.shape.rounded_rect,
	-- 				widget = wibox.container.background,
	-- 			},
	-- 			margins = 5,
	-- 			widget = wibox.container.margin,
	-- 		},
	-- 	},
	-- })
	for _, t in pairs(s.tags) do
		t.layout = awful.layout.suit.tile
	end
end)
