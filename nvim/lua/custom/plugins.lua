local cmp = require "cmp"

-- TODO: skonfigurowac ThePrimeagen/harpoon
-- FIX: sprawdzic co jest nie tak z trouble
-- TODO: konfiguracja skrutów
-- TODO: https://freshman.tech/vim-quickfix-and-location-list/
-- TODO: https://github.com/phaazon/hop.nvim
-- TODO: sidebar https://github.com/sidebar-nvim/sidebar.nvim
-- INFO: https://github.com/ecosse3/nvim/blob/master/lua/plugins/noice.lua
-- INFO: https://github.com/ecosse3/nvim/blob/master/lua/plugins/dressing.lua

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
        "lua-language-server",
        "typescript-language-server"
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
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return require("custom.configs.treesitter")
    end
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {},
  -- },
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
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    opts = function()
      return require "custom.configs.dashboard"
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function()
      return require("custom.configs.notice")
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
    }
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    -- opts = {}
    opts = function()
      return require("custom.configs.todo")
    end
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      return require("custom.configs.harpoon")
    end
  },
  {
    "folke/which-key.nvim",
    disable = false,
    config = function()
      local present, wk = pcall(require, "which-key")
      if not present then
        return
      end
      wk.register(
        {
          -- add group
          ["<leader>"] = {
            h = { name = "Harpoon" },
            t = { name = "Themes, Todo" },
            w = { name = "Which key" },
            g = { name = "Git" },
            n = { name = "Noice and Notify" },
            f = { name = "Find" },
            l = { name = "LSP" },
            m = { name = "Marks" },
          }
        }
      )
    end,
    setup = function()
      require("core.utils").load_mappings "whichkey"
    end,
  }
  -- {
  --   'sidebar-nvim/sidebar.nvim',
  --   opts = {open = true}
  -- },
}

return plugins
