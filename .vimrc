" ensure tabs are a nice length
highlight SignColumn ctermbg=0
highlight ColorColumn ctermbg=2 ctermfg=0
highlight MatchParen ctermfg=0

set mouse=a

set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set autoindent
"set smartindent

set hlsearch
set ignorecase
set ruler
set signcolumn=yes

set bg=dark
set cc=80

set wrap!

inoremap <S-Tab> <C-d>
set scrolloff=4
set noshowmode

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'
Plug '/usr/bin/fzf'

"Plug 'ntpeters/vim-better-whitespace'

" All for latex
Plug 'w0rp/ale'

Plug 'lervag/vimtex'

Plug 'neomake/neomake'

"Plug 'vim-syntastic/syntastic'

" Airline
Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

" Base 16
Plug 'chriskempson/base16-vim'

call plug#end()

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\}
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:airline#extensions#ale#enabled = 1
let g:airline_theme = 'monochrome'

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

let g:vimtex_indent_enabled=0

"let base16colorspace=256
if has('gui_running')
    " GUI colors
    colorscheme base16-default-light
else
    " Non-GUI (terminal) colors
    "colorscheme base16-gruvbox-dark-medium
endif

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

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink':   function('s:plug_help_sink')}))
