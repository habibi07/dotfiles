local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  -- Depending on typescript version either uri or targetUri is returned
  if value.uri then
    return string.match(value.uri, "%.d.ts") == nil
  elseif value.targetUri then
    return string.match(value.targetUri, "%.d.ts") == nil
  end
end

local M = {}

local on_attach = function(client, bufnr)
  -- Modifying a server's capabilities is not recommended and is no longer
  -- necessary thanks to the `vim.lsp.buf.format` API introduced in Neovim
  -- 0.8. Users with Neovim 0.7 needs to uncomment below lines to make tsserver formatting work (or keep using eslint).

  -- client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.documentRangeFormattingProvider = false

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  require("lsp-inlayhints").on_attach(client, bufnr)
end

local handlers = {}

local settings = {
  typescript = {
    inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = false,
      includeInlayEnumMemberValueHints = true,
    },
    suggest = {
      includeCompletionsForModuleExports = true,
    },
  },
  javascript = {
    inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = false,
      includeInlayEnumMemberValueHints = true,
    },
    suggest = {
      includeCompletionsForModuleExports = true,
    },
  },
}

M.on_attach = on_attach
M.handlers = handlers
M.settings = settings

return M