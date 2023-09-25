local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local M = {}

M.on_attach = on_attach
M.capabilities = capabilities
M.filetypes = { "python" }
M.settings = {
  pylsp = {
    plugins = {
      pycodestyle = {
        ignore = { 'W391', 'E501'},
        maxLineLength = 120
      }
    }
  }
}

return M
