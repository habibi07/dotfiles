local cmp = require "cmp"
local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "ruff",
        "prettier",
        "stylua",
        "python-lsp-server",
        -- "typescript-language-server"
      },
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = { "python", "javascript" },
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "rcarriga/nvim-notify"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function ()
      return require("custom.configs.treesitter")
    end
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      M.completion.completeopt = "menu,menuone,noselect"
      M.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      return M
    end,
  },
}

return plugins
