---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

M.telescope = {
  n = {
    ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "Find keymaps" },
  }
}

-- more keybinds!

return M
