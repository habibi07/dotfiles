pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
-- Notification library
--local naughty = require("naughty")
local menubar = require("menubar")
local translations = require("translations")
local hotkeys_popup = require("awful.hotkeys_popup")

local cairo = require("lgi").cairo
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


local volume_widget = require('widgets.volume.volume')
local ram_widget = require("widgets.ram.ram")
--local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
--local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

-- calendar, docekr, fs, ram, cpu, logout, mpd, todo, spotify, transmission, translate
--local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
--local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

local notify_normal = function(tekst)
  naughty.notify({
    preset = naughty.config.presets.normal,
    title = "Oops, there were errors during startup!",
    text = tekst
  })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Ojej, wystąpił błąd",
                     text = tostring(err) })
    in_error = false
  end)
end

-- variables
theme = "habibi"
browser = "brave"
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
user = os.getenv("USER")
editor_cmd = terminal .. " -e " .. editor
lang = string.sub(os.getenv("LANG"), 0, 2)
tag_list = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
modkey = "Mod4"
inc_factor = 0.05
useless_gap = 2
local rofi_cmd = 'rofi -show ssh'

beautiful.init("/home/" .. user .. "/.config/awesome/themes/" .. theme .. "/theme.lua")

-- set translation
local t = translations[lang]

-- functions 
local move_to_tag = function(t)
  if client.focus then
      client.focus:move_to_tag(t)
  end
end
local toggle_view = function(t) t:view_only() end
local next_view = function(t) awful.tag.viewnext(t.screen) end
local prev_view = function(t) awful.tag.viewprev(t.screen) end
local focus_next_client = function () awful.client.focus.byidx(1) end
local focus_prev_client = function () awful.client.focus.byidx(-1) end
local swap_next_client = function () awful.client.swap.byidx(1) end
local swap_prev_client = function () awful.client.swap.byidx(-1) end
local focus_next_screen = function () awful.screen.focus_relative(1) end
local focus_prev_screen = function () awful.screen.focus_relative(-1) end

local show_client_list = function() awful.menu.client_list({ theme = { width = 500, height = 50 } }) end
local show_terminal = function () awful.spawn(terminal) end
local show_rofi = function () awful.spawn(rofi_cmd) end
local incmwfactor = function () awful.tag.incmwfact(inc_factor) end
local decmwfactor = function () awful.tag.incmwfact(-inc_factor) end
local inc_masters = function () awful.tag.incnmaster( 1, nil, true) end
local dec_masters = function () awful.tag.incnmaster(-1, nil, true) end
local inc_columns = function () awful.tag.incncol( 1, nil, true) end
local dec_columns = function () awful.tag.incncol( -1, nil, true) end
local next_layout = function () awful.layout.inc( 1) end
local prev_layout = function () awful.layout.inc(-1) end
local run_prompt = function () awful.screen.focused().mypromptbox:run() end
local run_dmenu = function () awful.spawn("drun") end
local show_menubar = function() menubar.show() end
local move_to_master = function (c) c:swap(awful.client.getmaster()) end
local move_to_screen = function (c) c:move_to_screen() end
local increase_gap = function () awful.tag.incgap(useless_gap) end
local decrease_gap = function() awful.tag.incgap(-useless_gap) end
local keep_on_top = function (c) c.ontop = not c.ontop end
local maximize_horizontally = function (c)
  c.maximized_horizontal = not c.maximized_horizontal
  c:raise()
end
local maximize_vertically = function (c)
  c.maximized_vertical = not c.maximized_vertical
  c:raise()
end
local unmaximize_client = function (c)
  c.maximized = not c.maximized
  c:raise()
end
local minimize_client = function (c)
  -- The client currently has the input focus, so it cannot be
  -- minimized, since minimized clients can't have the focus.
  c.minimized = true
end

local client_fullscreen = function (c)
  c.fullscreen = not c.fullscreen
  c:raise()
end
local client_close = function (c) c:kill() end

local activate_focus_client = function (c)
  if c == client.focus then
    c.minimized = true
  else
    c:emit_signal(
      "request::activate",
      "tasklist",
      {raise = true}
    )
  end
end
local run_lua_code = function ()
  awful.prompt.run {
    prompt       = t.run_lua_code_text,
    textbox      = awful.screen.focused().mypromptbox.widget,
    exe_callback = awful.util.eval,
    history_path = awful.util.get_cache_dir() .. "/history_eval"
  }
end

local focus_prev_client = function ()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end
local restore_minimized = function ()
  local c = awful.client.restore()
  -- Focus restored client
  if c then
    c:emit_signal(
      "request::activate", "key.unminimize", {raise = true}
    )
  end
end
local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end
local launch_browser = function () awful.spawn(browser) end

local wrap_widget_in_powerline = function (wd)
    return {
        {
            {
                wd,
                widget = wibox.container.margin,
                left = 20,
                right = 20
            },
            bg = beautiful.tasklist_bg_focus,
            shape = gears.shape.powerline,
            widget = wibox.container.background,
        },
        widget = wibox.container.margin,
        left = -20,
        right = -20,
    }
end


-- layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.floating,
}

-- menu
awesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mainmenu = awful.menu({
  items = {
    { "awesome", awesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal }
  }
})
launcher = awful.widget.launcher({ 
  --image = beautiful.awesome_icon,
  image = "/usr/share/pixmaps/archlinux-logo.svg",
  menu = mainmenu
})

-- widgets
menubar.utils.terminal = terminal
keyboardlayout = awful.widget.keyboardlayout()
textclock = wibox.widget.textclock('%d-%m-%Y %H:%M')

-- taglist buttons
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, toggle_view),
  awful.button({ modkey }, 1, move_to_tag),
  --awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, move_to_tag)
  -- awful.button({ }, 4, next_view),
  -- awful.button({ }, 5, prev_view)
)

-- Lista otwartych okien
local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, activate_focus_client),
  awful.button({ }, 3, show_client_list),
  awful.button({ }, 4, focus_next_client),
  awful.button({ }, 5, focus_prev_client)
)


-- Ustaw tapete gdy zmieni sie geometria ekranu
-- screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(tag_list, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt { prompt = t.prompt_text}
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    local tag_callback = function(self, c3, index, objects) 
            local bg_widget = self:get_children_by_id('bg')[1]
            if c3.selected then
            	bg_widget.bg = beautiful.bg_normal
            else
		if #c3:clients() > 0 then
            		bg_widget.bg = beautiful.bg_normal .. "80"
		else
            		bg_widget.bg = beautiful.bg_normal .. "00"
		end
            end
    end

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
	widget_template = {
    	    {
    	        {
			{
				id = 'text_role',
				widget = wibox.widget.textbox,
			},
    	            widget = wibox.container.margin,
    	            left = 25,
    	            right = 25
    	        },
		id = 'bg',
    	        bg = beautiful.bg_normal .. "00",
    	        shape = gears.shape.powerline,
    	        widget = wibox.container.background,
    	    },
    	    widget = wibox.container.margin,
    	    left = -8,
    	    right = -8,
	    create_callback = tag_callback,
	    update_callback = tag_callback
    	}
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
	style = {
		shape = gears.shape.powerline,
	},
	layout = {
		layout = wibox.layout.fixed.horizontal
	},
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 20,
                right = 20,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.bar = awful.wibar({
	    position = "top",
	    screen = s,
	    width = '80%',
	    border_color = beautiful.bar_border_color,
	    border_width = beautiful.bar_border_width
        }
    )
    local separator = {
        {
            forced_width = beautiful.separator_width,
            color = beautiful.separator_color,
            orientation = "vertical",
            shape = gears.shape.powerline,
            widget = wibox.widget.separator
        },
        widget = wibox.container.margin,
        left = beautiful.separator_margin_left,
        right = beautiful.separator_margin_right,
        top = beautiful.separator_margin_top,
        bottom = beautiful.separator_margin_bottom
    }

    -- Add widgets to the wibox
    s.bar:setup {
	    {
		layout = wibox.layout.align.horizontal,
        	{ -- Left widgets
        	    layout = wibox.layout.fixed.horizontal,
        	    launcher,
		    separator,
		    s.mytaglist,
		    separator,
        	    s.mypromptbox,

        	},
		s.mytasklist,
        	{ -- Right widgets
        	    layout = wibox.layout.fixed.horizontal,
		    separator,
        ram_widget(),
		    volume_widget{
          widget_type = 'arc'
        },
        -- ram_widget(),
        -- cpu_widget(),
		    --battery_widget(),
		    separator,
        	    -- keyboardlayout,
        	    wibox.widget.systray(),
        	    textclock,
		    {
			    s.layoutbox,
			    margins = 10,
			    widget = wibox.container.margin
		    },
        	},
	    },
	    margins = 0,
	    widget = wibox.container.margin
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mainmenu:toggle() end)
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
-- Manager key bindings
  awful.key({ modkey, "Shift"}, "s", hotkeys_popup.show_help,
    {description=t.show_help, group = t.manager}),
  awful.key({ modkey, }, "s", show_rofi,
    {description="Run rofi ssh", group = t.manager}),
  awful.key({ modkey, }, "h", function () mainmenu:show() end,
    {description = t.show_menu, group = t.manager }),

-- client key bindings
  awful.key({ modkey, }, "j", focus_next_client,
    {description = t.focus_next_client, group = t.client}),
  awful.key({ modkey, }, "k", focus_prev_client,
    {description = t.focus_prev_client, group = t.client}),
  awful.key({ modkey, }, "i", increase_gap, {description = t.increase_gap, group = t.client}),
  awful.key({ modkey, }, "u", decrease_gap, {description = t.decrease_gap, group = t.client}),

-- Programs
  awful.key({ modkey, }, "w", launch_browser,
     {description = t.show_browser ,group = t.programs }),

-- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", swap_next_client,
    {description = t.swap_next_client, group = t.client }),
  awful.key({ modkey, "Shift"}, "k", swap_prev_client,
    {description = t.swap_prev_client, group = t.client }),
  awful.key({ modkey, "Control" }, "j", focus_next_screen,
    {description = t.focus_next_screen, group = t.screen}),
  awful.key({ modkey, "Control" }, "k", focus_prev_screen,
    {description = t.focus_prev_screen, group = t.screen}),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
    {description = t.jump_urgent, group = t.client}),
  awful.key({ modkey, }, "Tab", focus_next_client,
    {description = t.focus_next_client, group = t.client}),

-- Standard program
  awful.key({ modkey, }, "Return", show_terminal,
    {description = t.show_terminal, group = t.terminal}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = t.reload, group = t.manager}),
  awful.key({ modkey, "Shift" }, "q", awesome.quit,
    {description = t.quit, group = t.manager}),
  awful.key({ modkey, }, "l", incmwfactor,
    {description = t.increase_master_width , group = t.layout}),
  awful.key({ modkey, }, "h", decmwfactor,
    {description = t.decrease_master_width, group = t.layout}),

-- layout
  awful.key({ modkey, "Shift" }, "h", inc_masters,
    {description = t.increase_masters, group = t.layout}),
  awful.key({ modkey, "Shift"   }, "l", dec_masters,
    {description = t.decrease_masters, group = t.layout}),
  awful.key({ modkey, "Control" }, "h", inc_columns,
    {description = t.inc_columns, group = t.layout}),
  awful.key({ modkey, "Control" }, "l", dec_columns,
    {description = t.dec_columns, group = t.layout}),
  awful.key({ modkey, }, "space", next_layout,
    {description = t.next_layout, group = t.layout}),
  awful.key({ modkey, "Shift" }, "space", prev_layout,
    {description = t.prev_layout, group = t.layout}),

  awful.key({ modkey, "Control" }, "n", restore_minimized,
    {description = t.restore_minimized, group = t.client}),

-- Prompt
  awful.key({ modkey }, "r", run_dmenu,
    {description = t.run_prompt, group = t.launcher}),

  awful.key({ modkey }, "x", run_lua_code,
    {description = t.run_lua_code, group = t.manager}),
-- Menubar
  awful.key({ modkey }, "p", show_menubar,
    {description = t.show_menubar, group = t.launcher})
)

clientkeys = gears.table.join(
  awful.key({ modkey, }, "f", client_fullscreen,
    {description = t.client_fullscreen, group = t.client}),
  awful.key({ modkey }, "q", client_close,
    {description = t.close, group = t.client}),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
    {description = t.toggle_floating, group = t.client}),
  awful.key({ modkey, "Control" }, "Return", move_to_master,
    {description = t.move_to_master, group = t.client }),
  awful.key({ modkey, }, "o", move_to_screen,
    {description = t.move_to_screen, group = t.client }),
  awful.key({ modkey, }, "t", keep_on_top,
    {description = t.keep_on_top, group = t.client }),
  awful.key({ modkey, }, "n", minimize_client,
    {description = t.minimize, group = t.client }),
  awful.key({ modkey, }, "m", unmaximize_client,
    {description = t.unmaximize, group = t.client }),
  awful.key({ modkey, "Control" }, "m", maximize_vertically,
    {description = t.maximize_vertically, group = t.client }),
    awful.key({ modkey, "Shift"  }, "m", maximize_horizontally,
        {description = t.maximize_horizontally, group = t.client})
)

local function get_tag_function(key, i)
  local view_tag_handler = function ()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
       tag:view_only()
    end
  end
  local toggle_tag_handler = function ()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end

  local move_to_focused_tag_hanlder = function ()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:move_to_tag(tag)
      end
    end
  end

  local toggle_focused_on_tag_handler = function ()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:toggle_tag(tag)
      end
    end
  end

  local tag_functions = {
    view_tag = view_tag_handler;
    toggle_tag = toggle_tag_handler;
    move_focused_to_tag = move_to_focused_tag_hanlder;
    toggle_focused_on_tag = toggle_focused_on_tag_handler;
  }
  return tag_functions[key]
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, get_tag_function("view_tag", i), {description = t.view_tag..i, group = t.tag}),
      -- Toggle tag display.
      awful.key({ modkey, "Control" }, "#" .. i + 9, get_tag_function("toggle_tag", i), {description = t.toggle_tag .. i, group = t.tag}),
      -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9, get_tag_function("move_focused_to_tag", i), {description = t.move_focused_to_tag .. i, group = t.tag}),
      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, get_tag_function("toggle_focused_on_tag", i), {description = t.toggle_focused_on_tag .. i, group = t.tag})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {},
        name = {},
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
    {
        rule_any = {
            class = { "Brave-browser" }
        },
        properties = { 
		border_width  = beautiful.border_width,
		floating = false,
		border_color = beautiful.border_normal
	}
    }
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end


    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

local focus_client_handler = function(c)
  c.border_color = beautiful.border_focus
end
local unfocus_border_handler = function(c)
  c.border_color = beautiful.border_normal
end

client.connect_signal("focus", focus_client_handler)
client.connect_signal("unfocus", unfocus_border_handler)

