filetype plugin indent on
syntax enable
set nocompatible

set encoding=utf-8

set termguicolors
set keywordprg=":help"

set autoindent
set backspace=indent,eol,start

set ttimeout
set ttimeoutlen=50

set incsearch
set hlsearch

set laststatus=2
"set cursorline

set number
set relativenumber

set tabstop=2
set shiftwidth=2
set expandtab

"set numberwidth=5 " line number column width
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()

"colorscheme Atelier_ForestDark
"colorscheme space-vim-dark
"colorscheme Atelier_CaveDark
"colorscheme blackboard
"colorscheme cabin
colorscheme duotone-darkspace
"let g:python3_host_prog = "python3.10"

"colorscheme purify

"hi LineNr         ctermfg=DarkMagenta guifg=#2b506e guibg=#000000

nnoremap <SPACE> <Nop>
let mapleader = " "
let g:maplocalleader = ','
let g:mapleader = " "

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>

" setup required by coc plugin to work properly
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
