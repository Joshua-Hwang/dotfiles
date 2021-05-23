call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

Plug 'wellle/targets.vim'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'sheerun/vim-polyglot'
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
call plug#end()

set clipboard=unnamed
set hidden
set ignorecase smartcase
set mouse=a
set nowrap
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set nrformats+=alpha
set signcolumn=number
set cmdheight=2
set splitbelow
set splitright
set equalalways
set incsearch
set hlsearch
set number
set relativenumber
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j
set scrolloff=2
set autoread
set autoindent
set backspace=indent,eol,start
set laststatus=2
set ruler
set wildmenu
set sessionoptions=blank,buffers,curdir,help,tabpages
set viewoptions-=options
set showcmd

syntax on
filetype plugin on
filetype indent on

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

let NERDTreeQuitOnOpen=1

let g:session_autosave = 'no'

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

function MyNerdToggle()
    if &filetype == 'nerdtree'
        :NERDTreeToggle
    else
        :NERDTreeFind
    endif
endfunction

map <silent> <F12> :tabedit $MYVIMRC<CR>

map <silent> <C-b> :Buffers<CR>
map <silent> <C-f> :Files<CR>

map <silent> <F5> :SaveSession<CR>
map <silent> <F9> :OpenSession<CR>
map <silent> - :call MyNerdToggle()<CR>
