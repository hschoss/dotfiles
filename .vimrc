" CORE
set nocompatible            " vim mode
filetype plugin indent on   " filetype setup
colorscheme elflord         " high contrast
syntax on                   " syntax colors
set encoding=utf-8          " only UTF-8
set shortmess+=I            " hide intro message

" UI
set number relativenumber   " hybrid line numbers
set ruler                   " show cursor position
set showcmd                 " show pending command
set showmatch               " highlight matching bracket
set title                   " set window title
set scrolloff=5             " keep scroll context
set colorcolumn=78          " show column guide
set nowrap                  " disable line wrap
set linebreak               " wrap at words

" SEARCH
set ignorecase              " ignore lowercase search
set smartcase               " respect uppercase search
set incsearch               " search while typing
set hlsearch                " highlight all matches

" COMPLETION
set wildmenu               " show completion menu
set wildmode=longest,list  " complete then list

" INDENTATION
set expandtab              " use spaces
set tabstop=4              " display tab width
set shiftwidth=4           " indentation width
set softtabstop=4          " editing tab width
set autoindent             " copy previous indent
set smarttab               " indent with shiftwidth
set nojoinspaces           " avoid double spaces
set bs=indent,eol,start    " flexible backspace

" BUFFERS
set hidden                 " allow hidden buffers
set autoread               " reload changed files

" CLIPBOARD
if has('clipboard_provider') && executable('wl-copy') && executable('wl-paste')
    function! s:WlCopy(reg, type, lines) abort
        let l:cmd = ['wl-copy'] + (a:reg ==# '*' ? ['--primary'] : [])
        let l:text = join(a:lines, "\n") . (a:type ==# 'V' ? "\n" : "")

        let l:job = job_start(l:cmd, {
            \ 'in_io': 'pipe',
            \ 'out_io': 'null',
            \ 'err_io': 'null',
            \ })

        if job_status(l:job) !=# 'fail'
            call ch_sendraw(l:job, l:text)
            call ch_close_in(l:job)
        endif
    endfunction

    function! s:WlPaste(reg) abort
        let l:cmd = ['wl-paste']
            \ + (a:reg ==# '*' ? ['--primary'] : [])
            \ + ['--type', 'text/plain;charset=utf-8']

        return ['', systemlist(l:cmd)]
    endfunction

    let v:clipproviders['wl_clipboard'] = {
        \ 'available': {-> executable('wl-copy') && executable('wl-paste')},
        \ 'copy': {
        \   '+': function('s:WlCopy'),
        \   '*': function('s:WlCopy'),
        \ },
        \ 'paste': {
        \   '+': function('s:WlPaste'),
        \   '*': function('s:WlPaste'),
        \ },
        \ }

    set clipmethod=wl_clipboard,wayland,x11
    set clipboard=unnamedplus

elseif has('clipboard')
    set clipboard=unnamedplus

elseif executable('wl-copy')
    nnoremap <silent> yy yy:call system('wl-copy', @")<CR>
    xnoremap <silent> y y:call system('wl-copy', @")<CR>
endif

" MARKDOWN
let g:markdown_fenced_languages = [
    \ 'bash=sh',
    \ 'javascript',
    \ 'json',
    \ 'python',
    \ 'yaml',
    \ 'vim',
\]
let g:markdown_syntax_conceal = 0

" FILETYPES
augroup FiletypeSettings
  autocmd!
  autocmd FileType python
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4
        \ expandtab colorcolumn=88
  autocmd FileType vim
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
        \ expandtab
  autocmd FileType yaml
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
        \ expandtab
  autocmd FileType markdown
        \ setlocal wrap linebreak colorcolumn=80 textwidth=78
augroup END


" MAPPINGS
let mapleader = ' '

nnoremap <Leader>w :write<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>e :edit<CR>
nnoremap <Esc><Esc> :nohlsearch<CR>

nnoremap <Leader>sw :setlocal wrap! linebreak<CR>
nnoremap <Leader>ss :setlocal spell!<CR>
nnoremap <Leader>sr :set relativenumber!<CR>

nnoremap <Leader>dd a<C-r>=strftime('%Y-%m-%d')<CR><Esc>
nnoremap <Leader>tt a<C-r>=strftime('%H:%M')<CR><Esc>
nnoremap <Leader>dt a<C-r>=strftime('%Y-%m-%d %H:%M')<CR><Esc>
nnoremap <Leader>ts a<C-r>=strftime('%Y%m%d_%H%M%S')<CR><Esc>

" LOCAL
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
