let g:vimwiki_hl_headers = 1
" let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
let g:vimwiki_list = [{'path': '~/vimwiki', 'template_path': '~/vimwiki/templates/',
          \ 'template_default': 'default',
          \ 'syntax': 'markdown',
          \ 'ext': '.md',
          \ 'nested_syntaxes': {'python': 'python', 'c++': 'cpp', 'bash': 'bash'},
          \ 'auto_tags': 1,
          \ 'path_html': '~/vimwiki/site_html/',
          \ 'custom_wiki2html': 'vimwiki_markdown',
          \ 'html_filename_parameterization': 1,
          \ 'template_ext': '.tpl'}]
