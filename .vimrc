set nocompatible

filetype plugin indent on
syntax on

set number
set ruler
set showcmd
set wildmenu
set ignorecase
set smartcase
set incsearch
set hlsearch
set expandtab
set shiftwidth=4
set tabstop=4
set backspace=indent,eol,start

" Make normal yanks such as yy use the system clipboard when Vim supports it.
if has('clipboard')
    set clipboard=unnamedplus
elseif executable('wl-copy')
    nnoremap <silent> yy yy:call system('wl-copy', @")<CR>
    xnoremap <silent> y y:call system('wl-copy', @")<CR>
endif
