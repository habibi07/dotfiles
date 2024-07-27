local awful = require("awful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local utils = require('widgets.utils')

local volume = {}
local widget_types = {
  icon_and_text = require('widgets.volume.widgets.icon_and_text'),
  arc = require('widgets.volume.widgets.arc'),
}

local function GET_VOLUME_CMD() return 'pamixer --get-volume' end
local function CHANGE_VOLUME_CMD(step) return 'pactl set-sink-volume @DEFAULT_SINK@ ' .. step end
local function worker(user_args)
  local args = user_args or {}
  local widget_type = args.widget_type or 'icon_and_text'
  local step = user_args.step or 5
  local refresh_rate = args.refresh_rate or 1

  local function update_graphic(widget, stdout)
    widget:set_volume_level(stdout)
  end

  local function update_callback(stdout)
    spawn.easy_async(GET_VOLUME_CMD(), function (out)
      update_graphic(volume.widget, out)
    end)
  end

  function volume:inc(s)
    local volume_step = s or step
    local step_value = '+' .. volume_step .. '%'
    local cmd = CHANGE_VOLUME_CMD(step_value)
    spawn.easy_async(cmd, update_callback)
  end

  function volume:dec(s)
    local volume_step = s or step
    local step_value = '-' .. volume_step .. '%'
    local cmd = CHANGE_VOLUME_CMD(step_value)
    spawn.easy_async(cmd, update_callback)
  end
  
  volume.widget = widget_types[widget_type].get_widget(args)

  volume.widget:buttons(
    awful.util.table.join(
      awful.button({}, 4, function() volume:inc() end),
      awful.button({}, 5, function() volume:dec() end)
    )
  )

  watch(GET_VOLUME_CMD(), refresh_rate, update_graphic, volume.widget)

  return volume.widget
end


return utils.worker_widget(volume, worker)
