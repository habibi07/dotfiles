local capabilities = require("plugins.configs.lspconfig").capabilities

local M = {}


local baseDefinitionHandler = vim.lsp.handlers["textDocument/definition"]

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

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = true,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = true }),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = true }
  ),
  ["textDocument/definition"] = function(err, result, method, ...)
    P(result)
    require("notify")("My super important message")
    if vim.tbl_islist(result) and #result > 1 then
      local filtered_result = filter(result, filterReactDTS)
      return baseDefinitionHandler(err, filtered_result, method, ...)
    end

    baseDefinitionHandler(err, result, method, ...)
  end,
}

M.settings = {
  separate_diagnostic_server = true,
  tsserver_file_preferences = {
    includeInlayParameterNameHints = "all",
    includeCompletionsForModuleExports = true,
    quotePreference = "auto",
  },
}

M.on_attach = function(client, bufnr)
  vim.lsp.inlay_hint(bufnr, true)
  require("notify")("My super important message")
end

M.capabilities = capabilities
M.handlers = handlers

return M
