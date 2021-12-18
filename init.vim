syntax on

set nocompatible
set nu
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set backspace=indent,eol,start
set smartcase
set nohlsearch
set nobackup
set noswapfile
set clipboard=unnamedplus
set timeoutlen=600
set scrolloff=8
let mapleader=' '

call plug#begin()
	Plug 'morhetz/gruvbox'
	Plug 'neoclide/coc.nvim', {'branch' : 'release'}
	Plug 'vim-airline/vim-airline'
	Plug 'preservim/nerdtree'
	Plug 'lervag/vimtex'
	Plug 'tikhomirov/vim-glsl'
	"Plug 'plasticboy/vim-markdown'
	"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
call plug#end()

colorscheme gruvbox
set background=dark

highlight Normal ctermbg=none
highlight NonText ctermbg=none

nnoremap <leader>j :wincmd j<cr>
nnoremap <leader>k :wincmd k<cr>
nnoremap <leader>h :wincmd h<cr>
nnoremap <leader>l :wincmd l<cr>
nnoremap <leader>t gt
nnoremap <leader>T gT
