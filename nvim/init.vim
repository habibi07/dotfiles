call plug#begin()
Plug 'flazz/vim-colorschemes' " color schemes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " autocomletion
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' } " displays color boxes 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'jmcantrell/vim-virtualenv'
Plug 'tpope/vim-fugitive' " Git integration plugin
"Plug 'junegunn/fzf'
"Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/which-key.nvim'
Plug 'nvim-treesitter/nvim-treesitter' " for telescope 
Plug 'junegunn/goyo.vim' " toggles focus mode
Plug 'vimwiki/vimwiki'
Plug 'mattn/emmet-vim'
call plug#end()


" --------------------------------------------------- Load configs
source ~/.config/nvim/config/setcolors.vim
source ~/.config/nvim/config/global.vim
source ~/.config/nvim/config/vim-hexokinase.vim
source ~/.config/nvim/config/coc.vim
source ~/.config/nvim/config/vim-airline.vim
source ~/.config/nvim/config/vimwiki.vim
source ~/.config/nvim/config/nvim-treesitter.vim
source ~/.config/nvim/config/which-key.vim

" Matching brackets color override
highlight MatchParen cterm=bold ctermbg=NONE ctermfg=NONE
highlight MatchParen gui=bold,underline guibg=NONE guifg=#5c5c8a
