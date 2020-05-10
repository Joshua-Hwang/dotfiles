set mouse=a
set backspace=2
set clipboard=unnamedplus

set tabstop=8
set softtabstop=0
set expandtab
set wildmenu
set shiftwidth=4
set autoindent
"set smartindent
"set number

set hlsearch
set incsearch
set showcmd
set ignorecase
set ruler
set signcolumn=yes
set keywordprg=:Man

set nrformats+=alpha

set ttyfast
set bg=dark
set textwidth=80
set colorcolumn=80

set wrap!

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

inoremap <S-Tab> <C-d>
inoremap <M-n> <C-n>
set scrolloff=4
set noshowmode

nmap <F5> :make <Cr>
tnoremap <Esc> <C-\><C-n>

nmap <silent> <C-h> :wincmd h<Cr> 
nmap <silent> <C-j> :wincmd j<Cr> 
nmap <silent> <C-k> :wincmd k<Cr> 
nmap <silent> <C-l> :wincmd l<Cr> 

nmap <silent> <C-Tab> :tabnext<Cr>

" ~Fancy~
set conceallevel=0
map <F2> :set conceallevel=2 <Cr>
map <F3> :set conceallevel=0 <Cr>

filetype plugin on

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'preservim/nerdtree'
Plug 'chrisbra/Colorizer'

"Plug 'ntpeters/vim-better-whitespace'
Plug 'andymass/vim-matchup'

" All for latex
Plug 'lervag/vimtex'

Plug 'shime/vim-livedown'

"Plug 'vim-syntastic/syntastic'

" Airline
Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

" Base 16
Plug 'chriskempson/base16-vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" indent aligning
"Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'

" Conceal
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

call plug#end()

set statusline^=%{coc#status()}

let g:airline#extensions#ale#enabled = 1
let g:airline_theme = 'monochrome'

let g:matchup_matchparen_deferred = 1

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

let g:vimtex_indent_enabled=0
let g:matchup_override_vimtex=1

let g:livedown_browser = "firefox"

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gs :call CocAction('jumpDefinition', 'split')
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <M-r> <Plug>(coc-rename)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

map <C-n> :NERDTreeToggle<CR>

" Live preview
nmap gm :LivedownToggle<CR>

" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

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

let g:OmniSharp_server_stdio = 1

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
highlight IndentGuidesOdd ctermbg=235
highlight IndentGuidesEven ctermbg=236

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink':   function('s:plug_help_sink')}))

" ensure tabs are a nice length
highlight SignColumn ctermbg=0
highlight ColorColumn ctermbg=8 ctermfg=7
highlight MatchParen ctermfg=0
highlight Conceal ctermbg=235 ctermfg=231

highlight Pmenu ctermbg=0 ctermfg=15
highlight PmenuSel ctermbg=15 ctermfg=0
highlight PmenuSbar ctermbg=15 ctermfg=0
highlight PmenuThumb ctermbg=5 ctermfg=0
