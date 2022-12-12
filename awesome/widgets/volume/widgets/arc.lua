local beautiful = require('beautiful')
local wibox = require("wibox")
local widget = {}

function widget.get_widget(widget_args)
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
  local bg_color = args.bg_color or beautiful.bg_systray

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
    set_volume_level = function (self, new_value)
      local val 
      if tonumber(new_value) <= 100 then
        val = 100 - tonumber(new_value)
      else
        val = 100 - (tonumber(new_value) - 100)
      end
      self.value = string.format('%d', val)
      text.text = tostring(new_value) 
    end
  }
end

return widget 
