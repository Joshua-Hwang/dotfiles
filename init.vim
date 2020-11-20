call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

Plug 'bkad/CamelCaseMotion'
Plug 'wellle/targets.vim'

"Plug 'dense-analysis/ale'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/echodoc.vim'
Plug 'lervag/vimtex', { 'for': 'tex' }

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'junegunn/fzf'

Plug 'simnalamburt/vim-mundo'

"Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

Plug 'guns/xterm-color-table.vim'
Plug 'ryanoasis/vim-devicons'
" Momentum based scrolling
Plug 'yuttie/comfortable-motion.vim'
Plug 'nathanaelkane/vim-indent-guides'

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
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

autocmd CompleteDone * silent! pclose!
autocmd BufEnter * call ncm2#enable_for_buffer()

set hidden
set ignorecase
set smartcase
set mouse=a
set foldmethod=indent
set foldnestmax=1
set cc=80
set tw=79
set nowrap
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set nrformats+=alpha
set guifont=FiraCode\ Nerd\ Font\ Mono:h11
set completeopt=noinsert,menuone,noselect
set signcolumn=yes
set cmdheight=2
set splitbelow
set splitright
set noequalalways
"set omnifunc=ale#completion#OmniFunc
filetype plugin on
highlight SignColumn ctermbg=0
highlight Conceal ctermbg=233
highlight Pmenu ctermfg=7 ctermbg=233
highlight ColorColumn ctermbg=0

let g:echodoc_enable_at_startup = 1
let g:camelcasemotion_key = ','
let g:tex_flavor = 'latex'
"let g:vimtex_view_method = 'zathura'
let g:indent_guides_guide_size = 1
let g:vimtex_complete_recursive_bib = 1

let g:LanguageClient_serverCommands = {
    \ 'cpp': ['/usr/bin/clangd'],
    \ 'python': ['/home/joshua/.local/bin/pyls'],
    \ 'tex': ['/usr/bin/texlab'],
    \ }

tnoremap <silent> <C-left>  <C-\><C-N>:wincmd h<CR>
tnoremap <silent> <C-down>  <C-\><C-N>:wincmd j<CR>
tnoremap <silent> <C-up>    <C-\><C-N>:wincmd k<CR>
tnoremap <silent> <C-right> <C-\><C-N>:wincmd l<CR>
inoremap <silent> <C-left>  <C-\><C-N>:wincmd h<CR>
inoremap <silent> <C-down>  <C-\><C-N>:wincmd j<CR>
inoremap <silent> <C-up>    <C-\><C-N>:wincmd k<CR>
inoremap <silent> <C-right> <C-\><C-N>:wincmd l<CR>
nnoremap <silent> <C-left>  :wincmd h<CR>
nnoremap <silent> <C-down>  :wincmd j<CR>
nnoremap <silent> <C-up>    :wincmd k<CR>
nnoremap <silent> <C-right> :wincmd l<CR>

map <silent> <C-n> :NERDTreeToggle<CR>
map <silent> <F5> :MundoToggle<CR>
map <silent> <C-m> :FZF<CR>

nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> gi <Plug>(lcn-implementation)
nmap <silent> <C-k> <Plug>(lcn-menu)
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

map <silent> <F2> :5new<CR>:wincmd j<CR>:terminal<CR>

map <silent> <F12> :e ~/.config/nvim/init.vim<CR>
