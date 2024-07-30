" Automatically install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug install
call plug#begin('~/.local/share/nvim/plugged')

" Practice
Plug 'wikitopian/hardmode'
" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Text manipulation
Plug 'tomtom/tcomment_vim'

call plug#end()

"
" Custom configurations
" Copied from Thoughtbot dotfiles but modified to suit my need
"

" Leader
let mapleader = ","

let g:airline_powerline_fonts=1
let g:airline_theme='light'

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Toggle highlight search
nmap <leader>k :noh<CR>

" Netrw configurations
let g:netrw_keepdir=0
let g:netrw_liststyle=4
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_winsize=25
nmap <leader>b :Lexplore<CR>

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»\ ,trail:·,eol:¬,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Make it obvious where 80 characters is
set textwidth=80
let &colorcolumn="80,".join(range(120,999),",")
highlight ColorColumn ctermbg=0 guibg=lightgray

" Numbers
set number
set relativenumber

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Always use vertical diffs
set diffopt+=vertical

" Keep at least 10 lines visible
set scrolloff=10

" Enable Hardmode by default
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>
