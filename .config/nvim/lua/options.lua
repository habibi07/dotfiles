require "nvchad.options"
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.colorcolumn = "120"
o.clipboard = "unnamedplus"
o.showmatch = true     -- highlight matching parenthesis
o.splitright = true    -- vertical split to the right
o.splitbelow = true    -- horizontal split to the bottom
o.ignorecase = true    -- ignore case letters when search
o.smartcase = true     -- ignore lowercase for the whole pattern
o.linebreak = true     -- wrap on word boundary

o.hidden = true        -- enable background buffers
o.history = 100        -- remember n lines in history
-- o.lazyredraw = true -- faster scrolling
o.synmaxcol = 240      -- max column for syntax highlight

o.termguicolors = true -- enable 24-bit RGB colors

o.expandtab = true     -- use spaces instead of tabs
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true -- autoindent new lines
o.shell = 'zsh'
o.title=true

augroup("MyAutoCmdGroup", { clear = true })
autocmd("TextYankPost", {
  desc = "Highlights yanked text",
  group = "MyAutoCmdGroup",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = "200" }
  end,
})
autocmd("BufReadPost", {
  desc = "Open file at the last position it was edited earlier",
  group = "MyAutoCmdGroup",
  pattern = "*",
  command = 'silent! normal! g`"zv',
})
-- autocmd("BufWritePre", {
--   desc = "Format on save",
--   group = "MyAutoCmdGroup",
--   pattern = "*",
--   callback = function ()
--     vim.lsp.buf.format({ async = false})
--   end
-- })
