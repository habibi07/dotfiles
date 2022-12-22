local utils = require('widgets.utils')
local wibox = require("wibox")
local spawn = require("awful.spawn")

local powerbutton = {}
ICON = nil
POWERMENU_CMD = "powermenu"

local function get_widget(args)
  local icon = args.icon or ICON

  return wibox.widget {
    {
      {
        id = "icon",
        resize = false,
        image = icon,
        widget = wibox.widget.imagebox,
      },
      valign = 'center',
      layout = wibox.container.place
    },
    layout = wibox.layout.fixed.horizontal,
  }
end

local function worker(user_args)
  local args = user_args or {}

  powerbutton.widget = get_widget(user_args)

  powerbutton.widget:connect_signal("button::press", function ()
    spawn.easy_async(POWERMENU_CMD)
  end)

  return powerbutton.widget
end


return utils.worker_widget(powerbutton, worker)
