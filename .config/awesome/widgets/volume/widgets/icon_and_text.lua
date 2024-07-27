
local beautiful = require('beautiful')
local wibox = require("wibox")

local ICON_DIR = os.getenv("HOME") .. '/.config/awesome/widgets/icons/'

local ICON_MAP = {
  muted =  'audio-volume-muted-symbolic',
  low = 'audio-volume-low-symbolic',
  medium = 'audio-volume-medium-symbolic',
  high = 'audio-volume-high-symbolic'
}

local widget = {}

function widget.get_widget(widget_args)
  local args = widget_args or {}
  local font = args.font or beautiful.font
  local icon_dir = args.icon_dir or ICON_DIR

  return wibox.widget {
    {
      {
        id = "icon",
        resize = false,
        widget = wibox.widget.imagebox,
      },
      valign = 'center',
      layout = wibox.container.place
    },
    {
      id = 'txt',
      font = font,
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal,
    get_icon = function (self, state)
      local icon_name = ICON_MAP[state]
      return icon_dir .. icon_name .. '.svg'
    end,
    set_volume_state = function (self, state)
      self.state = state
      local icon = self:get_icon(self.state)
      self:set_icon(icon)
    end,
    set_icon = function (self, icon)
      self:get_children_by_id('icon')[1]:set_image(icon)
    end,
    set_volume_level = function (self, new_value)
      self:get_children_by_id('txt')[1]:set_text(new_value)
      local new_value_num = tonumber(new_value)
      local new_state
      if new_value_num == 0 then
        new_state = "muted"
      elseif new_value_num >= 0 and new_value_num < 33 then
        new_state = "low"
      elseif new_value_num >= 33 and new_value_num < 66 then
        new_state = "medium"
      else
        new_state = "high"
      end

      self:set_volume_state(new_state)
    end
  }
end

return widget 
