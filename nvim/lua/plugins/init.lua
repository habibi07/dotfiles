return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {}
    -- config = function() 
    --   require("mason").setup()
    -- end
    -- opts = function()
    --   return require "custom.mason"
    -- end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function() 
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ruff"}
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return require "custom.treesitter"
    end,
  },
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      return require "custom.dashboard"
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
  {
    "folke/noice.nvim",
    lazy = false,
    -- event = "VeryLazy",
    opts = function()
      return require "custom.notice"
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
    },
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
      return require "custom.todo"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      return require "custom.harpoon"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
      }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    enable = false,
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function()
      return require "custom.none-ls"
    end,
  },
}
