return {
  -- {
  --   "stevearc/conform.nvim",
  --   -- event = 'BufWritePre', -- uncomment for format on save
  --   config = function()
  --     require "configs.conform"
  --   end,
  -- },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function()
      return require "custom.mason"
    end,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        config = function()
          require("mason-lspconfig").setup {
            ensure_installed = { "lua_ls", "tsserver", "ruff", "pyright" },
            automatic_installation = true,
          }
        end,
      },
    },
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
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function()
      return require "custom.none-ls"
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "RRethy/vim-illuminate",
    init = function()
      require("illuminate").configure {}
    end,
  },
  {
    "LunarVim/breadcrumbs.nvim",
    -- lazy = false,
    dependencies = {
      { "SmiteshP/nvim-navic" },
    },
    init = function()
      require("nvim-navic").setup {
        lsp = {
          auto_attach = true,
        },
      }

      require("breadcrumbs").setup()
    end,
  },
{
    "vimwiki/vimwiki",
    event = "VimEnter",
    init = function()
      vim.g.vimwiki_hl_headers = 1
      vim.g.vimwiki_list = {
        {
          path = "~/vikis/vikis/",
          template_path = "~/vikis/templates/",
          template_default = "viki_template",
          path_html = "~/vikis/vikis_html",
          nested_syntaxes = {
            python = "python",
            javascript = "javascript",
            bash = "bash",
            sh = "sh",
            go = "go",
            node = "javascript",
          },
          syntax = "markdown",
          ext = "md",
          custom_wiki2html = "vimwiki_markdown",
          html_filename_parameterization = 1,
          auto_toc = 1,
          auto_tags = 1,
          template_ext = ".html",
        },
      }
    end,
  },
  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre", -- this will only start session saving when an actual file was opened
  --   opts = {
  --     -- add any custom options here
  --   },
  -- },
}
