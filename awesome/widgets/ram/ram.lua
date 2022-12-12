local beautiful = require('beautiful')
local wibox = require("wibox")
local utils = require('widgets.utils')
local watch = require("awful.widget.watch")

local ram_widget = {}

local RAM_FREE_PERCENT_CMD = 'bash -c "free | grep Mem | awk \'{ printf(\\"%.d\\",$4/$2 * 100.0) }\'"'

local function get_widget(widget_args)
  local args = widget_args or {}
  local font = args.font or beautiful.font
  local text = wibox.widget {
    font = font .. ' 6',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }
  local text_with_background = wibox.container.background(text)
  local size = 24
  local bg_color = args.bg_color or beautiful.fg_urgent

  text.text = "80"
  return wibox.widget {
    text_with_background,
    max_value = 100,
    rounded_edge = true,
    thickness = 4,
    start_angle = 4.71238898, -- 2pi*3/4
    value = 80,
    forced_height = size,
    forced_width = size,
    bg = bg_color,
    paddings = 2,
    widget = wibox.container.arcchart,
    set_ram = function (self, new_value)
      self.value = tonumber(80)
      text.text = new_value
    end
  }
end


local function worker(user_args)
  local args = user_args or {}
  local refresh_rate = args.refresh_rate or 1


  ram_widget.widget = get_widget(user_args)

  local function update_widget(w, stdout)
    w:set_ram(stdout)
  end

  watch(RAM_FREE_PERCENT_CMD , refresh_rate, update_widget, ram_widget.widget)

  return ram_widget.widget
end

return utils.worker_widget(ram_widget, worker)
