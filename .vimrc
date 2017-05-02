" Basic setup

set nocompatible
syntax enable
filetype plugin on
set number

" Finding files

set path+=**
set wildmenu

" Tag jumping

command! MakeTags !ctags -R -f ./.git/tags .
