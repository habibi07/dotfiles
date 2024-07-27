local null_ls = require "null-ls"
local notify = require "notify"
local ts_utils = require "nvim-treesitter.ts_utils"

null_ls.setup {
  debug = true,
  sources = {
    require "none-ls.diagnostics.eslint_d",
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.mypy.with {
      extra_args = function()
        local virtual = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX" or "/usr"
        -- return { "--python-executable", virtual .. "/bin/python3", "--install-types", '--non-interactive'}
        return { "--python-executable", virtual .. "/bin/python3" }
      end,
    },
  },
}

local function get_fun_predicate(node, params)
  -- if node == nil or node:type() ~= "identifier" then
  --   return false
  -- end
  --
  -- local parent = node:parent()
  -- if parent == nil or parent:type() ~= "function_definition" then
  --   return false
  -- end

  -- local node_text = vim.treesitter.get_node_text(node, params["bufnr"])

  return true
end

null_ls.register {
  method = null_ls.methods.CODE_ACTION,
  filetypes = { "python" },
  generator = {
    fn = function(params)
      local out = {}

      local node = vim.treesitter.get_node()
      if get_fun_predicate(node, params) then
        table.insert(out, {
          title = "aaa",
          action = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local node = ts_utils.get_node_at_cursor()
            -- local root = ts_utils.get_root_for_node(node)

            if node == nil then
              notify.notify "pusto"
            end
            local start_row = node:start()
            local parent = node:parent()

            if parent ~= nil then
              repeat
                node = parent
                parent = node:parent()
              until node:type() == "function_definition" or node:type() == "class_definition"
            end

            -- while parent ~= nil and parent:start() == start_row do
            -- while parent ~= nil and (parent:type() == "function_definition" or parent:type() == "class_definition") do
            --   -- notify.notify(ts_utils.get_node_text(node, bufnr))
            --   node = parent
            --   parent = node:parent()
            -- end

            ts_utils.update_selection(bufnr, node)
            -- notify.notify(vim.inspect(ts_utils))
            -- notify.notify(node_type)
            -- notify.notify(root:type())
            -- vim.fn.append(params["row"] - 1, "# OMG")
          end,
        })
      end
      return out
    end,
  },
}
