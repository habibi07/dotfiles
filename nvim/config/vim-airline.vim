let g:airline_theme='base16_material_palenight'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1

let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }

let g:airline_stl_path_style = 'short'
let g:airline_section_c_only_filename = 0

let g:airline_skip_empty_sections = 0
let g:airline_focuslost_inactive = 1
" let g:airline_statusline_ontop = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#whitespace#enabled = 1

" let g:airline_exclude_preview = 1

let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'


let g:airline#extensions#whitespace#trailing_format = 'trailing - %s'
let g:airline#extensions#whitespace#mixed_indent_format =
   \ 'mixed-indent - %s'
let g:airline#extensions#whitespace#long_format = 'long - %s'
let g:airline#extensions#whitespace#mixed_indent_file_format =
   \ 'mix-indent-file - %s'
let g:airline#extensions#whitespace#conflicts_format = 'conflicts - %s'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.linenr = '☰ l:'
let g:airline_symbols.colnr = ' c:'
let g:airline_symbols.maxlinenr = ''

let g:airline_section_c = '%t'
let g:airline_section_z = airline#section#create(['linenr', 'colnr', 'maxlinenr', ' %p%%'])
" let g:airline_section_y = airline#section#create_right([ 'fileformat' ]) 
" let g:airline_section_y = airline#section#create_right([ 'fencbomffmt' ]) 

let g:airline#extensions#virtualenv#enabled = 1


