-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- {{{ Main
local theme = {}
local themes_path = require("awful.util").getdir("config")
theme.wallpaper = "~/Pictures/Wallpapers/high-res-minimalist.jpg"
-- }}}

theme.tasklist_disable_task_name = true

-- {{{ Styles
theme.font = "DejaVu Sans Mono 9"

-- {{{ Colors
theme.fg_normal = "#DCDCCC"
theme.fg_focus = "#F0DFAF"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#3F3F3F"
theme.bg_focus = "#fb6376"
theme.bg_urgent = "#3F3F3F"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap = dpi(7)
theme.border_width = dpi(2)
theme.border_normal = "#3F3F3F"
theme.border_focus = "#fb6376"
theme.border_marked = "#CC9393"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
-- theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
theme.fg_widget = "#AECF96"
theme.fg_center_widget = "#88A175"
theme.fg_end_widget = "#FF5656"
theme.bg_widget = "#494B4F"
theme.border_widget = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel = themes_path .. "zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon = themes_path .. "zenburn/awesome-icon.png"
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile = themes_path .. "zenburn/layouts/tile.png"
theme.layout_tileleft = themes_path .. "zenburn/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "zenburn/layouts/tilebottom.png"
theme.layout_tiletop = themes_path .. "zenburn/layouts/tiletop.png"
theme.layout_fairv = themes_path .. "zenburn/layouts/fairv.png"
theme.layout_fairh = themes_path .. "zenburn/layouts/fairh.png"
theme.layout_spiral = themes_path .. "zenburn/layouts/spiral.png"
theme.layout_dwindle = themes_path .. "zenburn/layouts/dwindle.png"
theme.layout_max = themes_path .. "zenburn/layouts/max.png"
theme.layout_fullscreen = themes_path .. "zenburn/layouts/fullscreen.png"
theme.layout_magnifier = themes_path .. "zenburn/layouts/magnifier.png"
theme.layout_floating = themes_path .. "zenburn/layouts/floating.png"
theme.layout_cornernw = themes_path .. "zenburn/layouts/cornernw.png"
theme.layout_cornerne = themes_path .. "zenburn/layouts/cornerne.png"
theme.layout_cornersw = themes_path .. "zenburn/layouts/cornersw.png"
theme.layout_cornerse = themes_path .. "zenburn/layouts/cornerse.png"
-- }}}

function theme.at_screen_connect(s)
	local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
	local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
	local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
	local logout_menu = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

	local mybattery = battery_widget({
		show_current_level = true,
		margin_left = 3,
		margin_right = 3,
	})

	local mysystray = wibox.widget({
		{
			wibox.widget.systray(),
			left = 10,
			top = 2,
			bottom = 2,
			right = 10,
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
	})

	local mytextclock = wibox.widget.textclock("%H:%M %p", 10)

	local myvolume = volume_widget({ widget_type = icon })

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

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

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
	s.mywibox = awful.wibar({ position = "top", screen = s })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			s.mytaglist,
			s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 10,
			mysystray,
			myvolume,
			brightness_widget({
				type = "icon_and_text",
				percentage = true,
			}),
			mybattery,
			mytextclock,
			logout_menu(),
			s.mylayoutbox,
		},
	})
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
