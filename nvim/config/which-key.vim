let g:which_key_map =  {}
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

lua << EOF
  local wk = require("which-key")
  
  local visual_keymaps = {
    p = { "<cmd>:w !python<cr>", "Run selected in python" },
  }

  local normal_keymaps = {
    f = {
      name = "Pliki i inne",
      f = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "Find File" },
      g = { "<cmd>Telescope live_grep hidden=true<cr>", "Live GREP" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      b = { "<cmd>Telescope buffers<cr>", "Find buffer" },
      c = { "<cmd>tabedit $MYVIMRC<CR>", "Open vim config" },
      s = { "<cmd>update<CR>", "Save file" }
    },
    g = {
      name = "Git",
      l = { "<cmd>Telescope git_commits<CR>", "View git commits" }
    }
  }

  wk.register(normal_keymaps, {
    prefix = '<leader>',
    mode = 'n'
  })

  wk.register(visual_keymaps, {
    prefix = '<leader>',
    mode = 'v'
  })

  require('telescope').setup{
   defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key"
        }
      },
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
    }
  }
  
EOF


