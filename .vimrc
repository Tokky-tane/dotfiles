syntax on
set clipboard+=unnamed
set colorcolumn=80
set hlsearch
set number
set splitbelow
set splitright
set termwinsize=15x0
set autoindent
set expandtab
set softtabstop=2
set tabstop=2
set shiftwidth=2
set smartindent
inoremap <silent> jj <ESC>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
