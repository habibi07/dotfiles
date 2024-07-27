
local utils = {}

function utils.worker_widget(widget, worker)
  return setmetatable(
    widget,
    {
      __call = function (_, ...)
        return worker(...)
      end
    }
  )
end

return utils
