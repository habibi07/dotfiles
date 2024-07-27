-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- local servers = { "html", "cssls", "pylsp" }
local servers = { "lua_ls", "tsserver", "ruff", "pyright" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
      Lua = {
        completion = {
          showWord = "Disable",
          callSnippet = "Both",
        },
        hint = {
          enable = true,
        },
      },
    },
  }
end
