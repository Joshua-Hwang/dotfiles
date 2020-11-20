call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'

"Plug 'dense-analysis/ale'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'lervag/vimtex'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'junegunn/fzf'

Plug 'simnalamburt/vim-mundo'

"Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

Plug 'guns/xterm-color-table.vim'
Plug 'ryanoasis/vim-devicons'

call plug#end()

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
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd CompleteDone * silent! pclose!
autocmd BufEnter * call ncm2#enable_for_buffer()

set hidden
set ignorecase
set smartcase
set mouse=a
set foldmethod=indent
set foldnestmax=1
set cc=80
"set tw=79
set nowrap
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set nrformats+=alpha
set guifont=FiraCode\ Nerd\ Font\ Mono:h11
set completeopt=noinsert,menuone,noselect
set signcolumn=yes
"set omnifunc=ale#completion#OmniFunc
filetype plugin on
highlight SignColumn ctermbg=0
highlight Conceal ctermbg=233
highlight Pmenu ctermfg=7 ctermbg=233
highlight ColorColumn ctermbg=0

let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_complete_recursive_bib = 1

let g:LanguageClient_serverCommands = {
    \ 'cpp': ['/usr/bin/clangd'],
    \ 'python': ['/home/joshua/.local/bin/pyls'],
    \ 'tex': ['/usr/bin/texlab'],
    \ }

map <silent> <C-n> :NERDTreeToggle<CR>

map <silent> <F5> :MundoToggle<CR>
map <silent> <F12> :e ~/.config/nvim/init.vim<CR>

nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <C-k> <Plug>(lcn-menu)
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

map <silent> <C-left> :wincmd h<CR>
map <silent> <C-down> :wincmd j<CR>
map <silent> <C-up> :wincmd k<CR>
map <silent> <C-right> :wincmd l<CR>

map <F9> :call <SID>StripTrailingWhitespaces()<CR>
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

