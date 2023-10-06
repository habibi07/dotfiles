---@type MappingsTable

local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    -- ["<leader>s"] = { "<cmd> w <CR>", "Save current buffer" },
    -- ["<leader>q"] = { "<cmd> q <CR>", "Quit without save" },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

M.telescope = {
  n = {
    ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "Find keymaps" },
  }
}

M.todo = {
  n = {
    ["<leader>tt"] = { "<cmd> TodoTelescope <CR>", "Todo Telescope" },
  }
}

M.notice = {
  n = {
    ["<leader>nn"] = { "<cmd> Telescope noice <CR>", "Telescope noice" },
    ["<leader>nt"] = { "<cmd> Telescope notify <CR>", "Telescope notify" },
  }
}

M.lsp = {
  n = {
    ["<leader>lf"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },
    ["<leader>ld"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "LSP definition type",
    },

    ["<leader>lr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },


  }
}

M.whichkey = {
  n = {
    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "Add workspace folder",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "Remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        local pickers = require "telescope.pickers"
        local finders = require "telescope.finders"
        local conf = require("telescope.config").values
        local colors = function(opts)
          opts = opts or {}
          pickers.new(opts, {
            prompt_title = "Workspaces",
            finder = finders.new_table {
              results = vim.lsp.buf.list_workspace_folders()
            },
            sorter = conf.generic_sorter(opts),
          }):find()
        end
        colors()
        -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List workspace folders",
    },
  }
}

M.harpoon = {
  n = {
    ["<leader>ha"] = {
      function()
        require("harpoon.mark").add_file()
      end,
      "Harpoon add current buffer"
    },
    ["<leader>hh"] = {
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      "Harpoon quick menu"
    },
    ["<A-j>"] = {
      function()
        require("harpoon.ui").nav_next()
      end,
      "Harpoon quick menu"
    },
    ["<A-k>"] = {
      function()
        require("harpoon.ui").nav_prev()
      end,
      "Harpoon quick menu"
    },
  }
}
M.trouble = {
  n = {
    ["<leader>xx"] = {function() require("trouble").open() end, "Toggle trouble"},
    ["<leader>xw"] = {function() require("trouble").open("workspace_diagnostics") end, "Workspace diag."},
    ["<leader>xd"] = {function() require("trouble").open("document_diagnostics") end, "Document diag."},
    ["<leader>xq"] = {function() require("trouble").open("quickfix") end, "Quickfix"},
    ["<leader>xl"] = {function() require("trouble").open("loclist") end, "Trouble loc list"},
    ["<leader>xn"] = {function() require("trouble").next({skip_groups = true, jump = true}) end, "Trouble next"},
    ["<leader>xp"] = {function() require("trouble").previous({skip_groups = true, jump = true}) end, "Trouble next"},
  }
}


M.disabled = {
  n = {
    ["<leader>h"] = "",
    ["<leader>v"] = "",
    ["<leader>ca"] = "",
    ["<leader>D"] = "",
    ["<leader>ra"] = "",
    ["<leader>fm"] = "",
  },
}

return M
