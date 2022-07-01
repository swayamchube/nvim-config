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
set clipboard=unnamedplus " Install the xclip package for this to work
set timeoutlen=600
set scrolloff=8
let mapleader=' '

" Plugins
call plug#begin()
	Plug 'morhetz/gruvbox'
	Plug 'neoclide/coc.nvim', {'branch' : 'release'}
	Plug 'vim-airline/vim-airline'
	Plug 'preservim/nerdtree'
	Plug 'lervag/vimtex'
call plug#end()

" Colorscheme
colorscheme gruvbox
set background=dark

" Background with terminal colors (for transparency)
highlight Normal ctermbg=none 
highlight NonText ctermbg=none

" Normal Mode Remaps
nnoremap <leader>j :wincmd j<cr>
nnoremap <leader>k :wincmd k<cr>
nnoremap <leader>h :wincmd h<cr>
nnoremap <leader>l :wincmd l<cr>
nnoremap <leader>+ :vertical resize +5<cr>
nnoremap <leader>- :vertical resize -5<cr>
nnoremap <leader>t gt
nnoremap <leader>T gT
nnoremap <leader>y "+yy
nnoremap <F4> :NERDTreeToggle<cr>

" Insert Mode Remaps
inoremap { {}<left>
inoremap {<cr> {<cr>}<esc>O
inoremap {{ {
inoremap {} {}

" Visual Mode Remaps
vnoremap <leader>y "+y

"autocmds
autocmd	filetype cpp nnoremap <F9> :w<bar> !g++ -std=c++17 % -o %:r<cr>
