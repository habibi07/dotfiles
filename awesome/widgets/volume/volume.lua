
local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local beautiful = require('beautiful')
local watch = require("awful.widget.watch")

local volume = {}

local ICON_DIR = os.getenv("HOME") .. '/.config/awesome/widgets/icons/'

local GET_VOLUME_CMD = 'pamixer --get-volume'
local CHANGE_VOLUME_CMD = 'pactl set-sink-volume @DEFAULT_SINK@ '

local ICON_MAP = {
  muted =  'audio-volume-muted-symbolic',
  low = 'audio-volume-low-symbolic',
  medium = 'audio-volume-medium-symbolic',
  high = 'audio-volume-high-symbolic'
}

local function get_widget(widget_args)
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
      {
        id = 'txt',
        font = font,
        widget = wibox.widget.textbox
      },
      top = '12',
      left = 5,
      widget = wibox.container.margin,
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

local function worker(user_args)
  local args = user_args or {}
  local step = user_args.step or 5
  local refresh_rate = args.refresh_rate or 1

  local function update_graphic(widget, stdout)
    widget:set_volume_level(stdout)
  end

  local function update_callback(stdout)
    spawn.easy_async(GET_VOLUME_CMD, function (out)
      update_graphic(volume.widget, out)
    end)
  end

  function volume:inc(s)
    local volume_step = s or step
    local cmd = CHANGE_VOLUME_CMD .. '+' .. volume_step .. '%'
    spawn.easy_async(cmd, update_callback)
  end

  function volume:dec(s)
    local volume_step = s or step
    local cmd = CHANGE_VOLUME_CMD .. '-' .. volume_step .. '%'
    spawn.easy_async(cmd, update_callback)
  end

  volume.widget = get_widget(args)

  volume.widget:buttons(
    awful.util.table.join(
      awful.button({}, 4, function() volume:inc() end),
      awful.button({}, 5, function() volume:dec() end)
    )
  )

  --volume.widget:set_volume_level('12')
  watch(GET_VOLUME_CMD, refresh_rate, update_graphic, volume.widget)

  return volume.widget
end

return setmetatable(
  volume,
  {
    __call = function (_, ...)
      return worker(...)
    end
  }
)
