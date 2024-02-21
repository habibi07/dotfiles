local lspconfig = require "lspconfig"
local notify = require "notify"

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local pylsp = require "custom.configs.lsp.pylsp"
-- local tstools = require("custom.configs.lsp.tstools")
local tsserver = require "custom.configs.lsp.tsserver"
local tsutils = require "nvim-lsp-ts-utils"

lspconfig.pylsp.setup {
  on_attach = pylsp.on_attach,
  capabilities = pylsp.capabilities,
  filetypes = pylsp.filetypes,
  settings = pylsp.settings,
}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

local servers = { "tsserver", "tailwindcss", "eslint" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

local function move_to_file()
  local source_file, target_file

  -- vim.ui.input({
  --   prompt = "Source : ",
  --   completion = "file",
  --   default = vim.api.nvim_buf_get_name(0),
  -- }, function(input)
  --   source_file = input
  -- end)

  -- command = "_typescript.applyCodeAction",
  --
  local bufnr = vim.api.nvim_get_current_buf()
  local source = vim.api.nvim_buf_get_name(bufnr)
  -- local params = {
  --   command = "_typescript.applyRefactoring",
  --   {
  --     action = "Move to a new file",
  --     endLine = 3,
  --     endOffset = 10,
  --     file = "/home/habibi/data/workdir/myapp/src/app/page.js",
  --     refactor = "Move to a new file",
  --     startLine = 3,
  --     startOffset = 10,
  --   },
  -- }

  -- local params = {
  --   command = "_typescript.organizeImports",
  --   arguments = {
  --     source,
  --   },
  -- }

  -- local resp = vim.lsp.buf.execute_command(params)

  notify.notify(package.path)
end

local function rename_file()
  local source_file, target_file

  vim.ui.input({
    prompt = "Source : ",
    completion = "file",
    default = vim.api.nvim_buf_get_name(0),
  }, function(input)
    source_file = input
  end)
  vim.ui.input({
    prompt = "Target : ",
    completion = "file",
    default = source_file,
  }, function(input)
    target_file = input
  end)

  local params = {
    command = "_typescript.applyRenameFile",
    arguments = {
      {
        sourceUri = source_file,
        targetUri = target_file,
      },
    },
    title = "",
  }

  vim.lsp.util.rename(source_file, target_file)
  vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
    MyCommand = {
      move_to_file,
      description = "Move selected to file",
    },
    RenameFile = {
      rename_file,
      description = "Rename File",
    },
  },
}
-- notify.notify(vim.inspect(lspconfig.tsserver))
-- notify.notify(vim.inspect(tsutils))
--
-- lspconfig.tsserver.setup {
--   -- Needed for inlayHints. Merge this table with your settings or copy
--   -- it from the source if you want to add your own init_options.
--   init_options = require("nvim-lsp-ts-utils").init_options,
--   --
--   on_attach = function(client, bufnr)
--     local ts_utils = require "nvim-lsp-ts-utils"
--
--     -- defaults
--     ts_utils.setup {
--       debug = false,
--       disable_commands = false,
--       enable_import_on_completion = false,
--
--       -- import all
--       import_all_timeout = 5000, -- ms
--       -- lower numbers = higher priority
--       import_all_priorities = {
--         same_file = 1, -- add to existing import statement
--         local_files = 2, -- git files or files with relative path markers
--         buffer_content = 3, -- loaded buffer content
--         buffers = 4, -- loaded buffer names
--       },
--       import_all_scan_buffers = 100,
--       import_all_select_source = false,
--       -- if false will avoid organizing imports
--       always_organize_imports = true,
--
--       -- filter diagnostics
--       filter_out_diagnostics_by_severity = {},
--       filter_out_diagnostics_by_code = {},
--
--       -- inlay hints
--       auto_inlay_hints = true,
--       inlay_hints_highlight = "Comment",
--       inlay_hints_priority = 200, -- priority of the hint extmarks
--       inlay_hints_throttle = 150, -- throttle the inlay hint request
--       inlay_hints_format = { -- format options for individual hint kind
--         Type = {},
--         Parameter = {},
--         Enum = {},
--         -- Example format customization for `Type` kind:
--         -- Type = {
--         --     highlight = "Comment",
--         --     text = function(text)
--         --         return "->" .. text:sub(2)
--         --     end,
--         -- },
--       },
--
--       -- update imports on file move
--       update_imports_on_move = false,
--       require_confirmation_on_move = false,
--       watch_dir = nil,
--     }
--
--     -- required to fix code action ranges and filter diagnostics
--     ts_utils.setup_client(client)
--
--     -- no default maps, so you may want to define some here
--     local opts = { silent = true }
--     vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
--     vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
--     vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
--   end,
-- }
