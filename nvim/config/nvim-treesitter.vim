lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "python", "vim", "css", "dockerfile", "go", "html", "java", "javascript", "json", "markdown", "regex", "sql", "toml", "tsx", "typescript", "vue", "yaml" },
  sync_install = true,
  auto_install = true,
  ignore_install = { },
  autotag = {
    enable = true,
  },
  indent = {
    enable = true
  },
  highlight = {
    enable = true,
    disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },
}

EOF
