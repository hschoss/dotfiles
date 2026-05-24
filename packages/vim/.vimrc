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

nnoremap <Space>w :w<CR>

" aktuelles Datum einfügen
nnoremap <leader>dt a<C-r>=system('date +"%Y-%m-%d"')<CR><Esc>

" Datum
nnoremap <leader>dt a<C-r>=strftime("%Y-%m-%d")<CR><Esc>

" Datum + Zeit
nnoremap <leader>tt a<C-r>=strftime("%Y-%m-%d %H:%M")<CR><Esc>

" Timestamp für Dateien
nnoremap <leader>ts a<C-r>=strftime("%Y%m%d_%H%M%S")<CR><Esc>


" R mode
set colorcolumn=78
set relativenumber

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
