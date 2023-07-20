let g:which_key_map =  {}
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

lua << EOF
  local wk = require("which-key")
  
  local visual_keymaps = {
    name = 'Uruchom w python\'ie',
    p = { ":'<,'>w !python<cr>", "Run selected in python" },
  }

  local normal_keymaps = {
    p = { "<cmd>:w !python<cr>", "Run selected in python" },
    f = {
      name = "Pliki i inne",
      -- f = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "Find File" },
      -- g = { "<cmd>Telescope live_grep hidden=true no_ignore=true<cr>", "Live GREP" },
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      g = { "<cmd>Telescope live_grep<cr>", "Live GREP" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      b = { "<cmd>Telescope buffers<cr>", "Find buffer" },
      c = { "<cmd>tabedit $MYVIMRC<CR>", "Open vim config" },
      s = { "<cmd>update<CR>", "Save file" },
      q = { ":q!<CR>", "Quit without save" },
    },
    g = {
      name = "Git",
      c = { "<cmd>Telescope git_commits<CR>", "View git commits" },
      b = { "<cmd>Telescope git_branches<CR>", "View git branches" },
      g = { "<cmd>Telescope git_status<CR>", "Git status" },
      s = { "<cmd>Telescope git_stash<CR>", "View git Stashes" }
    },
    t = {
      name = "Telescope",
      r = { "<cmd>Telescope registers<CR>", "Registers"}, 
    },
  }

  wk.register(normal_keymaps, {
    prefix = '<leader>',
    mode = 'n'
  })

  wk.register(visual_keymaps, {
    prefix = '<leader>',
    mode = 'v'
  })

  -- local previewers = require("telescope.previewers")
  -- local pickers = require("telescope.pickers")
  -- local sorters = require("telescope.sorters")
  -- local finders = require("telescope.finders")
  -- 
  -- local clip = pickers.new {
  --   results_title = "Resources",
  --   finder = finders.new_oneshot_job({"greenclip", "print"}),
  --   sorter = sorters.get_fuzzy_file(),
  --   previewer = previewers.vim_buffer_cat.new {}
  -- }

  require('telescope').setup{
    defaults = {
      layout_config = {
        vertical = { width = 0.5 }
      },
      -- Default configuration for telescope goes here:
      -- config_key = value,
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key",
          ["<Esc>"] = "close"
        }
      },
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
    },
    pickers = {
      clip = clip
    }
  }

EOF


