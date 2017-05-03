set shell=bash

" Use the Solarized Dark theme
set background=dark
colorscheme solarized
let g:solarized_termtrans=1

" Basic setup

set nocompatible
set nobackup
set noswapfile
set number
set backspace=indent,eol,start

syntax enable
filetype plugin on

" Finding files

set path+=**
set wildmenu
