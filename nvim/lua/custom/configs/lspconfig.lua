local lspconfig = require("lspconfig")

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local pylsp = require("custom.configs.lsp.pylsp")
-- local tstools = require("custom.configs.lsp.tstools")
local tsserver = require("custom.configs.lsp.tsserver")

lspconfig.pylsp.setup {
  on_attach = pylsp.on_attach,
  capabilities = pylsp.capabilities,
  filetypes = pylsp.filetypes,
  settings = pylsp.settings
}
--
-- require("typescript-tools").setup{
--   settings = tstools.settings,
--   on_attach = tstools.on_attach,
--   handlers = tstools.handlers
-- }

lspconfig.tsserver.setup {
  on_attach = tsserver.on_attach,
  settings = tsserver.settings,
  handlers = tsserver.handlers
}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}
