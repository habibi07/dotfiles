local null_ls = require "null-ls"

null_ls.setup {
  debug = true,
  sources = {
    require "none-ls.diagnostics.eslint_d",
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
  },
}
