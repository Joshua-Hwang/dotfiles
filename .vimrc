" ensure tabs are a nice length
highlight SignColumn ctermbg=0
highlight ColorColumn ctermbg=235 ctermfg=1
highlight MatchParen ctermfg=0
highlight Conceal ctermbg=235 ctermfg=231

set mouse=a
set backspace=2
set clipboard=unnamedplus

set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set autoindent
"set smartindent

set hlsearch
set ignorecase
set ruler
set signcolumn=yes

set nrformats+=alpha

set ttyfast
set bg=dark
let &colorcolumn=join(range(81,999),",")

set wrap!

inoremap <S-Tab> <C-d>
set scrolloff=4
set noshowmode

nmap <F5> :make <Cr>

nmap <S-h> <C-w>h
nmap <S-j> <C-w>j
nmap <S-k> <C-w>k
nmap <S-l> <C-w>l

" ~Fancy~
set conceallevel=0
map <F2> :set conceallevel=2 <Cr>
map <F3> :set conceallevel=0 <Cr>

filetype plugin on

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

Plug 'chrisbra/Colorizer'

"Plug 'ntpeters/vim-better-whitespace'
Plug 'andymass/vim-matchup'

" All for latex
Plug 'w0rp/ale'

"Plug 'sheerun/vim-polyglot'

Plug 'lervag/vimtex'

"Plug 'neomake/neomake'

"Plug 'vim-syntastic/syntastic'

" Airline
Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

" Base 16
Plug 'chriskempson/base16-vim'

" Kernel Normal Form
"Plug 'vivien/vim-linux-coding-style'
Plug 'ninjin/vim-openbsd'

" indent aligning
"Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'

" Conceal
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

call plug#end()

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'tex': [],
\}
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_ballons = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:airline#extensions#ale#enabled = 1
let g:airline_theme = 'monochrome'

let g:matchup_matchparen_deferred = 1

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

let g:vimtex_indent_enabled=0
let g:matchup_override_vimtex=1

function! s:plug_help_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
highlight IndentGuidesOdd ctermbg=235
highlight IndentGuidesEven ctermbg=236

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink':   function('s:plug_help_sink')}))
