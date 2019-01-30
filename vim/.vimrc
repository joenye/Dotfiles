set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround' 
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/gv.vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-vinegar'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'airblade/vim-rooter'
Plug 'w0rp/ale'
Plug 'farmergreg/vim-lastplace'
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'janko-m/vim-test'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tommcdo/vim-exchange' " cxiw and .
Plug 'kassio/neoterm'
Plug 'simeji/winresizer'
Plug 'chriskempson/base16-vim'
Plug 'hdima/python-syntax'
Plug 'RRethy/vim-illuminate'
Plug 'junegunn/goyo.vim'

" Front-end
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mattn/emmet-vim'
Plug 'elzr/vim-json'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'othree/html5.vim'
Plug 'Valloric/MatchTagAlways'

" Autocomplete
Plug 'ervandew/supertab'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'zchee/deoplete-jedi'
Plug 'Rip-Rip/clang_complete'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'joenye/vim-snippets'

call plug#end()

if has('nvim')
  if (has('termguicolors'))
    set termguicolors
  endif
  tmap <c-o> <c-\><c-n>
  syntax on
  colorscheme base16-tomorrow-night
  " Transparent background
  hi normal guibg=none ctermbg=none 
else
  set ttymouse=xterm2
  set ttyfast
  filetype plugin indent on
  " Terminal colours
  if filereadable(expand('~/.vimrc_background'))
      let base16colorspace=256
  colorscheme base16-default-dark
  source ~/.vimrc_background
  endif
endif

" === Fugitive ===
nnoremap <silent> <leader>gs :Gstatus<cr>
" Note that :Gvdiff forces vertical split, else horizontal is used
" if the window is not wide enough
nnoremap <silent> <leader>gd :Gvdiff<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gb :Gblame<cr>
nnoremap <silent> <leader>gl :GV<cr>
nnoremap <silent> <leader>gp :Git push<cr>
" nnoremap <silent> <leader>gw :Gwrite<cr>
" nnoremap <silent> <leader>gr :Gread<cr>
nnoremap <silent> <leader>gi :Git add -p %<cr>
nnoremap <silent> <leader>ge :Gedit :0<cr>

" === Deoplete (uses insert-mode completion) ===
let g:deoplete#enable_at_startup = 1
" Configure in-built insert-mode completion to scan loaded buffers, current and included files
set complete=.,w,b,u,i
set completeopt=longest,menuone,preview,noinsert,noselect
" Don't show typed word in completion menu
call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy', 'matcher_length'])

" These can't live in ftplugins, since they need to be loaded when deoplete starts
let default_sources = ['buffer', 'tag', 'file', 'ultisnips']
call deoplete#custom#option('sources', {
\ '_': default_sources,
\ 'python': default_sources + ['jedi'],
\ 'c': default_sources + ['clang_complete'],
\ 'javascript.jsx': default_sources + ['ternjs'],
\ })

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:echodoc#enable_at_startup = 1
autocmd CompleteDone * silent! pclose!
set shortmess+=c
inoremap <expr><cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ "\<TAB>" :
          \ deoplete#mappings#manual_complete()
" <C-x>: close popup and delete backword char
inoremap <expr><C-x> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
inoremap <silent><expr> <c-space> deoplete#mappings#manual_complete()
inoremap <silent><expr> <esc> pumvisible() ? "<c-e><esc>" : "<esc>"

" === UltiSnips ===
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" === Netrw ===
let g:netrw_list_hide= '.*\.swp$,.*\.pyc,.*\.sw*,.*\.un~'
let g:netrw_liststyle=3
let g:netrw_menu=0
let g:netrw_winsize=10

" === Rooter ===
set autochdir
let g:rooter_patterns = ['node_modules/', '.git', '.git/']
let g:rooter_manual_only = 1 " Commands that care about dir should invoke rooter

" === NERDTree ===
let NERDTreeIgnore = ['\.pyc$', '^__pycache__$', '\.sw.$', '\.un\~']
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let g:NERDTreeMapQuit = 'qq'
let NERDTreeChDirMode=2
" Only use toggle for directory
" map <C-l> :NERDTreeToggle<CR>
map <C-n> :NERDTreeFind<CR>
let g:NERDTreeDirArrowExpandable = '├'
let g:NERDTreeDirArrowCollapsible = '└'
let g:NERDTreeMapActivateNode = '<tab>'
let g:NERDTreeQuitOnOpen=1

" === FZF ===
set rtp+=~/.fzf
let g:fzf_history_dir = '~/.local/share/fzf-history'
nmap ; :Buffers<cr>
nmap <leader>e :Rooter<cr><bar>:Tags<cr>
nmap <leader>r :Rooter<cr><bar>:Files<cr>
nmap <leader>i :Rooter<cr><bar>:Files<cr>
nmap <leader>l :Lines<cr>
nmap <leader>a :Rooter<cr><bar>:Rg<cr>
nmap <leader>h :History<cr>
command! CmdHist call fzf#vim#command_history({'right': '40'})
command! QHist call fzf#vim#search_history({'right': '40'})
let g:fzf_layout = { 'down': '~25%' }

" === ALE ===
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_delay = 500
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_sign_column_always = 1
let g:ale_python_mypy_options = '--ignore-missing-imports --follow-imports=silent'
let g:ale_linters = {
\   'python': ['flake8'],
\   'javascript': ['standard'],
\   'c': ['clang']
\}
" \   'javascript': ['eslint'],
" \   'c': ['clang', 'clangtidy']
" \   'python': ['flake8', 'mypy', 'pylint', 'yapf'],
let g:ale_fixers = {
\  'javascript': ['standard'],
\  'c': ['clang-format']
\}
" \  'javascript': ['prettier'],
nmap <leader>f <plug>(ale_fix)
nmap <silent> <leader>j :ALENext<cr>
nmap <silent> <leader>k :ALEPrevious<cr>

" === Emmet ===
nmap <expr> <leader>, emmet#expandAbbrIntelligent('\<space>')
let g:user_emmet_settings = {
\   'javascript.jsx' : {
\       'extends' : 'jsx',
\    },
\}

" === Lightline ===
augroup YourGroup
    autocmd!
    autocmd User ALELint call lightline#update()
augroup END
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:all_non_errors == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction
function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction
function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓' : ''
endfunction
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \          [ 'percent' ],
      \              [ 'linter_warnings', 'linter_errors', 'linter_ok' ],
      \          [ 'filetype', 'fileencoding', 'fileformat' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'ok'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" === Clipboard ===
" TODO: Replace when wl-protocols stabilise and are actually used:
" https://github.com/neovim/neovim/issues/9213
let g:clipboard = {
\   'name': 'wl-clipboard',
\   'copy': {
\      '+': 'wl-copy --foreground',
\      '*': 'wl-copy --foreground --primary',
\    },
\   'paste': {
\      '+': 'wl-paste --no-newline',
\      '*': 'wl-paste --no-newline --primary',
\   },
\   'cache_enabled': 1,
\ }

" === MatchTagAlways ===
let g:mta_filetypes = {}
" let g:mta_filetypes = {
" \ 'html' : 1,
" \ 'xhtml' : 1,
" \ 'xml' : 1,
" \ 'jinja' : 1,
" \ 'javascript.jsx' : 0,
" \}

" === Testing ===
let test#strategy = 'neoterm'
let g:neoterm_size = '15'
let g:neoterm_autoscroll = 1
let g:neoterm_autoinsert = 1
let g:neoterm_default_mod = ':botright'
let g:test#preserve_screen = 1
nnoremap <silent> <leader>tn :TestNearest<cr>
nnoremap <silent> <leader>tv :TestNearest -v<cr>
nnoremap <silent> <leader>tl :TestLast<cr>
nnoremap <silent> <leader>tf :TestFile<cr>

" === Illuminate ===
let g:Illuminate_ftblacklist = ['nerdtree']

" === Miscellaneous ===
map <space> <leader>
" Try and use <c-[> when jj is not possible
inoremap jj <esc>

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Prevent highlighting being funky
autocmd BufEnter,InsertLeave * :syntax sync fromstart

" Reverses default behaviour so that j and k move down/up by display lines,
" while gj and gk move by real lines
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" Always search forward with n and backward with N
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" Unsets the 'last search pattern' register by hitting return
nnoremap <cr> :noh<cr><cr>

" Ctrl-a behaviour
map <c-a> <esc>ggVG<cr>

set pastetoggle=<F3>
nnoremap <F4> :UndotreeToggle<cr>

" Copy current file path
nnoremap <silent> <leader>c :let @+=expand('%:p')<cr>

" Easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Treat all header files as C files
autocmd BufRead,BufNewFile *.h,*.c set filetype=c

" https://github.com/mxw/vim-jsx/issues/124
hi link xmlEndTag xmlTag

set mouse=a
set noshowmode
set splitbelow
set splitright
set showcmd
set hidden
set cursorline
set undofile
set showmatch
set hlsearch
set lazyredraw
set ignorecase
set smartcase

" Don't litter swp files everywhere
set backupdir=~/.cache
set directory=~/.cache

" Use w!! to write file as root
cmap w!! %!sudo tee > /dev/null % 

" Allow per-directory .vimrc overrides
set exrc
set secure
