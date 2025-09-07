pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local rubato = require("lib.rubato")

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
	c.shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 15) -- 10 là độ bo góc
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	if c.class == "Alacritty" then
		c.floating = true
		c:geometry({ x = -800, y = 100, width = 800, height = 500 })

		local x_anim = rubato.timed({
			pos = -800,
			rate = 60,
			intro = 0.1,
			duration = 0.3,
			easing = rubato.quadratic, -- mượt hơn
			subscribed = function(pos)
				if c.valid then
					local g = c:geometry()
					g.x = pos
					c:geometry(g)
				end
			end,
		})

		x_anim.target = 200 -- điểm đến cuối cùng
	end
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- Khi chuyển sang màn hình khác

local handling_screen_change = false

client.connect_signal("property::screen", function(c)
	if c.class ~= "Alacritty" then
		return
	end
	if handling_screen_change then
		return
	end

	handling_screen_change = true

	local g = c.screen.workarea
	local margin = 20

	if c.screen.index == 2 then
		if not c.floating then
			c.floating = true
		end
		c:geometry({
			x = g.x + margin,
			y = g.y + margin,
			width = g.width - margin * 2,
			height = g.height - margin * 2,
		})
	elseif c.screen.index == 1 then
		if c.floating then
			c.floating = false
		end
	end

	handling_screen_change = false
end)

-- }}}
