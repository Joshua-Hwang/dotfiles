call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

Plug 'wellle/targets.vim'

Plug 'kshenoy/vim-signature'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

Plug 'jlanzarotta/bufexplorer'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'sheerun/vim-polyglot'
Plug 'cocopon/iceberg.vim'
Plug 'guns/xterm-color-table.vim'

Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

Plug 'dense-analysis/ale'
Plug 'prabirshrestha/vim-lsp'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'
call plug#end()

augroup SaveManualFolds
    autocmd!
    au BufWinLeave, BufLeave ?* silent! mkview
    au BufWinEnter           ?* silent! loadview
augroup END

au BufRead * normal zR

" If another buffer tries to replace NERDTree, put it in the other window, and
" bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
     \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
function MyNerdToggle()
    if &filetype == 'nerdtree'
        :NERDTreeToggle
    else
      if bufname() == ''
        :NERDTreeToggle
      else
        :NERDTreeFind
      endif
    endif
endfunction

function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    inoremap <expr> <C-n> pumvisible() ? "\<C-n>" :"\<C-x><C-o>"
    inoremap <expr> <C-p> pumvisible() ? "\<C-p>" :"\<C-x><C-o>"
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 60000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

set clipboard=unnamed
set hidden
set ignorecase smartcase
set mouse=a
set nowrap
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set nrformats+=alpha
set signcolumn=yes
set cmdheight=2
set splitbelow
set splitright
set equalalways
set incsearch
set hlsearch
set number
set relativenumber
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set list
set formatoptions+=j
set scrolloff=2
set autoread
set autoindent
set backspace=indent,eol,start
set laststatus=2
set ruler
set wildmenu
set wildcharm=<C-z>
set sessionoptions=blank,buffers,curdir,help,tabpages,folds
set viewoptions-=options
set showcmd
set encoding=UTF-8
set nobackup
set nowritebackup
set belloff=all
set updatetime=300
set shortmess+=c
set foldmethod=manual
set foldcolumn=1
set completeopt=menuone,popuphidden,noselect,noinsert

syntax on
filetype plugin on
filetype indent on

colorscheme iceberg
if has("gui_running")
  if has("win32")
    set guifont=CaskaydiaCove\ NF:h12
    set renderoptions=type:directx
  endif
  if has("macunix")
    set guifont=MesloLGS\NF:h13
  endif
endif

let &t_SI = "\e[5 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[1 q"
let &t_ut = ''

let NERDTreeQuitOnOpen=1

let g:session_autosave='yes'
let g:session_autosave_to='default'
let g:session_autoload='no'
let g:session_persist_colors=0
let g:session_persist_font=0

let g:matchparen_timeout=2
let g:matchparen_insert_timeout=2

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
let myUndoDir = expand(vimDir . '/undodir')
" Create dirs
call system('mkdir ' . vimDir)
call system('mkdir ' . myUndoDir)
let &undodir = myUndoDir
set undofile

" Show syntax highlighting groups for word under cursor
nmap <F2> :call <SID>SynStack()<CR>
map <silent> <F12> :tabedit $MYVIMRC<CR>

map <silent> [t :tabp<CR>
map <silent> ]t :tabn<CR>

map <silent> <C-b> :Buffers<CR>
map <silent> <C-f> :Files<CR>

map <silent> <F5> :SaveSession<CR>
map <silent> <F9> :OpenSession<CR>

map <silent> _ :call MyNerdToggle()<CR>

map <silent> + :ToggleBufExplorer<CR>
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowNoName=1

let g:ale_disable_lsp = 1
"let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_sign_column_always = 1

let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'ruby': ['rubocop'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'ruby': ['rubocop'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\}

let g:lsp_diagnostics_echo_cursor = 1
if executable('solargraph')
    " gem install solargraph
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
endif
if executable('typescript-language-server')
    " npm install -g typescript typescript-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
        \ })
endif

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
