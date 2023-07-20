
lua << EOF
  require('telescope').setup{
    defaults = { 
      file_ignore_patterns = {"env", "node_modules", "__pycache__"}
    }
  }
EOF
