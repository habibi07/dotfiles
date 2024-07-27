require "nvchad.mappings"
local trouble = require "trouble.providers.telescope"

local telescope = require "telescope"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

-- NOTE: nie dziala takie wylaczenie mapowania, znalesc inne
nomap("n", "<leader>n")
nomap("n", "<leader>h")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map("n", "<leader>fm", require("conform").format, { desc = "format code" })
map("n", "<leader>fm", vim.lsp.buf.format, { desc = "format code" })
map("n", "<leader>ft", ":TodoTelescope<cr>", { desc = "Todo telescope list" })

map("n", "<leader>xx", function()
  require("trouble").toggle()
end, { desc = "Trouble toggle" })
map("n", "<leader>xw", function()
  require("trouble").toggle "workspace_diagnostics"
end, { desc = "Trouble workspace diag." })
map("n", "<leader>xd", function()
  require("trouble").toggle "document_diagnostics"
end, { desc = "Trouble document diag" })
map("n", "<leader>xq", function()
  require("trouble").toggle "quickfix"
end, { desc = "Toggle trouble quickfix" })
map("n", "<leader>xl", function()
  require("trouble").toggle "loclist"
end, { desc = "Toggle trouble loclist" })
map("n", "gR", function()
  require("trouble").toggle "lsp_references"
end, { desc = "Trouble LSP references" })

map("n", "<leader>fk", ":Telescope keymaps<cr>", { desc = "Find keymap" })
map("n", "<leader>j", ":cnext<cr>zz", { desc = "Quickfix next" })
map("n", "<leader>k", ":cprev<cr>zz", { desc = "Quickfix previous" })

map("i", "<C-o>", "<ESC> o", { desc = "Go to next line" })

telescope.setup {
  defaults = {
    mappings = {
      -- i = { ["<c-t>"] = trouble.open_with_trouble },
      -- n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}

local wk = require "which-key"
wk.register {
  ["<leader>n"] = {
    name = "Notifications",
    n = { ":Telescope notify<cr>", "Notify find" },
  },
  ["<leader>h"] = {
    name = "harpoon",
    a = { ":lua require('harpoon.mark').add_file()<cr>", "Add file" },
    f = { ":Telescope harpoon marks<cr>", "Find harpoons" },
    n = { ":lua require('harpoon.ui').nav_next()<cr>", "Next" },
    p = { ":lua require('harpoon.ui').nav_prev()<cr>", "Next" },
  },
}

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

-- map("n", "<leader>as", ':lua require("persistence").save()<cr>', { desc = "Save session" })
-- map("n", "<leader>al", ':lua require("persistence").load({ last = true })<cr>', { desc = "Restore session" })
