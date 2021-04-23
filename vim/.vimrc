scriptencoding utf-8
set nocompatible

" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "
try
  if empty(glob('~/.vim/autoload/plug.vim'))
    echo 'Installing vim plug...'
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    echo 'Installed vim plug successfully.'
  endif
catch
  'Failed to install. Install manually.'
endtry

try
  call plug#begin('~/.vim/plugged')

  " === Editing === "

  " Legend
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-surround'

  " Intellisense (auto-completion, linting, fixing - combines Ale and Deoplete)
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Minimal - only for exceptional filetypes - no key mappings or lightline integration
  " Plug 'w0rp/ale'

  " Trailing whitespace highlighting & automatic fixing
  Plug 'ntpeters/vim-better-whitespace'

  " Auto-close brackets
  Plug 'rstacruz/vim-closer'

  " Return to last place in file upon re-opening
  Plug 'farmergreg/vim-lastplace'

  " Test running
  Plug 'vim-test/vim-test'

  " HTML Abbreviations expansion
  Plug 'mattn/emmet-vim'

  " Switch into tmux easily
  Plug 'christoomey/vim-tmux-navigator'

  " cxiw and .
  Plug 'tommcdo/vim-exchange'

  " Highlight matching characters
  Plug 'RRethy/vim-illuminate'

  " Always highlight XML/HTML tags
  Plug 'Valloric/MatchTagAlways'

  " Nice undo tree
  Plug 'mbbill/undotree'

  " :GV, :GV! git browser
  Plug 'junegunn/gv.vim'

  " Use 'o' for older, 'O' for newer, 'q' to close,
  Plug 'rhysd/git-messenger.vim'

  " Snippets
  Plug 'SirVer/ultisnips'
  Plug 'joenye/vim-snippets'

  " Generate JSDoc based on signature
  Plug 'heavenshell/vim-jsdoc', {
    \ 'for': ['javascript', 'javascript.jsx', 'typescript'],
    \ 'do': 'make install'
  \}

  " Good when sharing screen
  Plug 'junegunn/goyo.vim'

  " === Syntax Highlighting === "

  let g:polyglot_disabled = ['markdown']
  Plug 'sheerun/vim-polyglot'

  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

  " === UI/Menus === "

  " Fuzzy-finding, buffer management
  Plug 'Shougo/denite.nvim'
  Plug 'neoclide/coc-denite'

  " fern.vim
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/glyph-palette.vim'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/fern-mapping-project-top.vim'
  Plug 'LumaKernel/fern-mapping-reload-all.vim'

  " Theme
  Plug 'rakr/vim-one'

  " Status bar
  Plug 'itchyny/lightline.vim'

  " <C-e>
  Plug 'simeji/winresizer'

  " === Tools === "
  Plug 'hrj/vim-DrawIt'

  " Remove once NeoVim bug is fixed: https://github.com/neovim/neovim/issues/12587
  Plug 'antoinemadec/FixCursorHold.nvim'

  call plug#end()

catch
  echo 'Vim plug not installed. Attempting to install...'
endtry

" ============================================================================ "
" === MAPPINGS ===
" ============================================================================ "

" Remap leader key to <space>
map <space> <leader>

" Search
map <leader>h :%s///<left><left>
nmap <silent> <leader>/ :nohlsearch<CR>
" Unsets the 'last search pattern' register by hitting return
nnoremap <cr> :noh<cr><cr>
" Always search forward with n and backward with N
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Use :Todo to edit todos
command! -nargs=0 Todo :e ~/Notes/GTD/TODOs.md

" Reverses default behaviour so that j and k move down/up by display lines, while gj and gk move by real lines
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" Copy current file path
nnoremap <silent> <leader>c :let @+=expand('%:p')<cr>

" Easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

if has('nvim')
  " Escape nvim terminal
  tmap <c-o> <c-\><c-n>
  nmap <C-h> <C-w>h
  nmap <C-l> <C-w>l
endif

" Delete current visual selection and dump in black hole buffer before pasting
" Used when you want to paste over something without it getting copied to Vim's default buffer
vnoremap <leader>p "_dP

" Use w!! to write file as root
cmap w!! w !sudo tee %

set pastetoggle=<F3>

" Note: use <c-[> when jj is not possible
inoremap jj <esc>

" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Ctrl-a behaviour
map <C-a> <esc>ggVG<cr>

" Better than default 4 seconds for Coc lint updates
set updatetime=1000

" === undotree ===
nnoremap <F4> :UndotreeToggle<cr>

" === vim-fugitive ===
nnoremap <silent> <leader>gs :Gstatus<cr>
" Note :Gvdiff forces vertical split, else horizontal is used if the window is not wide enough
nnoremap <silent> <leader>gd :Gvdiff<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gb :Gblame<cr>
nnoremap <silent> <leader>gl :GV<cr>
nnoremap <silent> <leader>gp :Git push<cr>
nnoremap <silent> <leader>gi :Git add -p %<cr>
nnoremap <silent> <leader>ge :Gedit :0<cr>

" === vim-test ===
nnoremap <silent> <leader>tn :TestNearest<cr>
nnoremap <silent> <leader>tv :TestNearest -v<cr>
nnoremap <silent> <leader>tl :TestLast<cr>
nnoremap <silent> <leader>tf :TestFile<cr>

" === emmet-vim ===
nmap <expr> <leader>, emmet#expandAbbrIntelligent('\<space>')
let g:user_emmet_settings = {
\   'javascript.jsx' : {
\       'extends' : 'jsx',
\    }
\}

" === vim-better-whitespace === "
" Remove all trailing witespace
nmap <silent> <leader>Y :StripWhitespace<CR>

" === coc.nvim ===
let g:coc_global_extensions = [
  \ 'coc-eslint',
  \ 'coc-cfn-lint',
  \ 'coc-yank',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-prettier',
  \ 'coc-css',
  \ 'coc-pyright',
  \ 'coc-tsserver',
  \ 'coc-marketplace']

" Use :Prettier to format file
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Extension-specific fix action on current item and selection
nmap <silent> <leader>da <Plug>(coc-codeaction)
xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Extension-specific format on selection
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Jump around code
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Rename current word
nmap <leader>dr <Plug>(coc-rename)

" Jump between diagnostics
nmap <silent> <leader>j <Plug>(coc-diagnostic-next)
nmap <silent> <leader>k <Plug>(coc-diagnostic-prev)

" coc-yank
nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

" === vim-jsdoc ===
nmap <leader>z :JsDoc<CR>

" Use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

augroup CocGroup
	autocmd!
  " Force show signature help on placeholder jump
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" === denite.nvim ===

" Denite 3.0+ removes denite#custom#map overrides and forces you to specify mappings
" There's 2 modes on filter window: normal mode ("filter mode") and insert mode
autocmd FileType denite call s:denite_my_settings()
	function! s:denite_my_settings() abort
    " Wrap contents locally
    setlocal wrap
    " Typically opens the file
	  nnoremap <silent><buffer><expr> <CR>
	  \ denite#do_map('do_action')
	  nnoremap <silent><buffer><expr> d
	  \ denite#do_map('do_action', 'delete')
    " Open preview window
	  nnoremap <silent><buffer><expr> p
	  \ denite#do_map('do_action', 'preview')
	  nnoremap <silent><buffer><expr> v
	  \ denite#do_map('do_action', 'vsplit')
	  nnoremap <silent><buffer><expr> q
	  \ denite#do_map('quit')
    " Switch to insert ("filter") mode
	  nnoremap <silent><buffer><expr> i
	  \ denite#do_map('open_filter_buffer')
	  nnoremap <silent><buffer><expr> +
	  \ denite#do_map('toggle_select').'j'
endfunction

" ,         - Browse currently open buffers (not using ; since that repeats f-search); starts in normal mode
" <leader>r - Browse list of files in current project directory, respecting .gitignore; starts in insert ("filter") mode
" <leader>t - Browse list of files in current project directory, ignoring .gitignore; starts in insert ("filter") mode
" <leader>r - Browse list of files in current directory; starts in insert ("filter") mode
" <leader>a - Browse contents of files in current directory; starts in insert ("filter") mode
nmap , :<C-u>Denite buffer -default-action=switch<CR>
nmap <silent> <leader>r :<C-u>DeniteProjectDir -start-filter -resume -buffer-name=file_gitignore file/rec/git<CR>
nmap <silent> <leader>t :<C-u>DeniteProjectDir -start-filter -resume -buffer-name=file_no_gitignore file/rec<CR>
nmap <leader>a :<C-u>DeniteProjectDir -start-filter -resume -buffer-name=content_gitignore grep:::!<CR>
nmap <leader>s :<C-u>Denite -start-filter -resume -buffer-name=content_no_gitignore grep:::!<CR>
nmap <leader>cd :<C-u>Denite coc-diagnostic<CR>
nmap <leader>cc :<C-u>Denite coc-command<CR>

" https://github.com/rafi/vim-config/blob/d7cdc594e73dfbca76b4868505f19db94f088a64/config/plugins/all.vim
" nnoremap <silent><LocalLeader>r :<C-u>Denite -resume -refresh -no-start-filter<CR>
" nnoremap <silent><LocalLeader>f :<C-u>Denite file/rec<CR>
" nnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register<CR>
" xnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register -default-action=replace<CR>
" nnoremap <silent><LocalLeader>l :<C-u>Denite location_list -buffer-name=list<CR>
" nnoremap <silent><LocalLeader>q :<C-u>Denite quickfix -buffer-name=list<CR>
" nnoremap <silent><LocalLeader>n :<C-u>Denite dein<CR>
" nnoremap <silent><LocalLeader>g :<C-u>Denite grep -no-start-filter<CR>
" nnoremap <silent><LocalLeader>j :<C-u>Denite jump change file/point -buffer-name=jump<CR>
" nnoremap <silent><LocalLeader>u :<C-u>Denite junkfile:new junkfile<CR>
" nnoremap <silent><LocalLeader>o :<C-u>Denite outline<CR>
" nnoremap <silent><LocalLeader>s :<C-u>Denite session -buffer-name=list<CR>
" nnoremap <silent><LocalLeader>t :<C-u>Denite -buffer-name=tag tag:include<CR>
" nnoremap <silent><LocalLeader>p :<C-u>Denite jump -buffer-name=jump<CR>
" nnoremap <silent><LocalLeader>h :<C-u>Denite help<CR>
" nnoremap <silent><LocalLeader>m :<C-u>Denite file/rec -buffer-name=memo -path=~/docs/books<CR>
" nnoremap <silent><LocalLeader>z :<C-u>Denite z<CR>
" nnoremap <silent><LocalLeader>/ :<C-u>Denite line -start-filter<CR>
" nnoremap <silent><LocalLeader>* :<C-u>DeniteCursorWord line<CR>
" nnoremap <silent><LocalLeader>; :<C-u>Denite command command_history<CR>

autocmd FileType denite-filter call s:denite_my_filter_settings()
function! s:denite_my_filter_settings() abort
    " Switch to normal mode
    imap <silent><buffer> <C-o> <Plug>(denite_filter_update)
	  imap <silent><buffer> <expr>dd denite#do_map('restart')
endfunction

" === fern.vim ===

map <silent> <C-n> :Fern %:p:h -drawer -stay -reveal=%:p<cr>
nmap <silent> - :Fern %:p:h -opener=edit -stay -reveal=%:p<cr>

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

function! s:init_fern() abort
  " Define NERDTree-like mappings
  nmap <buffer> o <Plug>(fern-action-open:edit)
  nmap <buffer> mm <Plug>(fern-action-move)
  nmap <buffer> ma <Plug>(fern-action-new-path)
  nmap <buffer> md <Plug>(fern-action-remove)
  nmap <buffer> mc <Plug>(fern-action-copy)
  nmap <buffer> u <Plug>(fern-action-leave)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> R <Plug>(fern-action-reload:all)
  nmap <buffer> a <Plug>(fern-action-rename)
  nmap <buffer> t <Plug>(fern-action-project-top:reveal)
  nmap <buffer><expr> <Plug>(fern-my-quit-or-return)
        \ fern#smart#drawer(
        \   ":<C-u>quit<CR>",
        \   "<C-o>",
        \ )
  nmap <buffer><nowait> q <Plug>(fern-my-quit-or-return)

  " Unmap Fern defaults to allow navigating between windows without doing <C-w><C-*>
  silent! nunmap <buffer> <C-h>
  silent! nunmap <buffer> <C-l>
  silent! nunmap <buffer> <C-j>
  silent! nunmap <buffer> <C-k>

  " Unmap \rwp so <leader>r doesn't wait
  silent! nunmap \rwp

  " Unmap m, c so mm, ma, md, mc works smoothly
  silent! nunmap <buffer> m
  silent! nunmap <buffer> c

  " Unmap default :StripWhitespace
  silent! xunmap <leader>s

  " Smart expand
  nmap <buffer><expr>
      \ <Plug>(fern-smart-expand-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-collapse)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )

  nmap <buffer><nowait> l <Plug>(fern-smart-expand-collapse)

endfunction

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Smart search
set ignorecase
set smartcase

" Disable line numbers
set nonumber

" Don't show last command
set noshowcmd

" Hides buffers instead of closing them
set hidden

" Highlight current cursor line, except on entering
autocmd! InsertEnter,InsertLeave * set cul!

" Close preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Only one line for command line
set cmdheight=1

" Enable mouse
set mouse=a

" Allow per-directory .vimrc overrides
set exrc
set secure

" Automatically re-read file if external change detected
set autoread

" Don't litter swp files everywhere
set backup
set backupdir=~/.cache/vim/backup
set swapfile
set directory=~/.cache/vim/swap
set undofile
set undodir=~/.cache/vim/undo

" Show preview of changes when using :substitute
set inccommand=nosplit

" ============================================================================ "
" ===                           UI/MENU OPTIONS                            === "
" ============================================================================ "

" Enable true color support
if has('nvim')
  set termguicolors
endif
if !exists('g:syntax_on')
	syntax enable
endif

" Add custom highlights in method that is executed every time a colorscheme is sourced
" See https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
" and https://github.com/junegunn/goyo.vim/issues/84
function! MyHighlights() abort
  " Highlight trailing whitespace
  highlight Trail ctermbg=red guibg=red
  call matchadd('Trail', '\s\+$', 100)

  " Transparent background
  hi Normal ctermbg=NONE guibg=NONE
  hi NonText ctermbg=NONE guibg=NONE
  hi LineNr ctermfg=NONE guibg=NONE
  hi SignColumn ctermfg=NONE guibg=NONE
  hi StatusLine guifg=#16252b guibg=#6699CC
  hi StatusLineNC guifg=#16252b guibg=#16252b
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END

try
  let g:one_allow_italics = 1
  colorscheme one
catch
  colorscheme slate
endtry

" Don't give completion messages like 'match 1 of 2' or 'The only match'
set shortmess+=c

" Preview window appears at bottom
set splitbelow

" Don't display mode in command line (lightline already shows)
set noshowmode

" Always display sign column
set signcolumn=yes

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type

" https://github.com/mxw/vim-jsx/issues/124
hi link xmlEndTag xmlTag

" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of preview window when open
function! Handle_Win_Enter()
  if &previewwindow
    setlocal winhighlight=Normal:MarkdownError
  endif
endfunction

" Highlight current line only on active buffer
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Consistent highlighting (even if opening for example coc-yank window)
highlight Cursor guifg=default guibg=default
highlight iCursor guifg=default guibg=default

" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

" == markdown-preview ===
let g:mkdp_browser = 'firefox'

" == vim-markdown ===
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_mappings = 0

" === vim-jsx === "
" Highlight jsx syntax even in non .jsx files
let g:jsx_ext_required = 0

" === vim-jsdoc === "
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_enable_es6 = 1
let g:jsdoc_underscore_private = 1

" === ultisnips ===
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" === MatchTagAlways ===
let g:mta_filetypes = {}
" let g:mta_filetypes = {
" \ 'html' : 1,
" \ 'xhtml' : 1,
" \ 'xml' : 1,
" \ 'jinja' : 1,
" \ 'javascript.jsx' : 0,
" \}

" === fern.vim ===
let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1
let g:fern#drawer_keep = 1
let g:fern#scheme#file#show_absolute_path_on_root_label = 1

" Disable netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

" === vim-test ===
let test#strategy = 'neoterm'
let g:neoterm_size = '15'
let g:neoterm_autoscroll = 1
let g:neoterm_autoinsert = 1
let g:neoterm_default_mod = ':botright'
let g:test#preserve_screen = 1

" === goyo.vim ===
" https://github.com/junegunn/goyo.vim/issues/160
autocmd! User GoyoLeave silent! ctermbg=NONE guibg=NONE

" === lightline ===
let g:lightline_symbol_map = {
  \ 'error': '💩',
  \ 'warning': '⚠️',
  \ 'info': '🔧',
  \ 'hint': '🔧'
  \ }

function! s:lightline_coc_diagnostic(kind, sign) abort
  let info = get(b:, 'coc_diagnostic_info', 0)
  if empty(info) || get(info, a:kind, 0) == 0
    return ''
  endif
  try
    let s = g:lightline_symbol_map[a:sign]
  catch
    let s = ''
  endtry
  return printf('%s %d', s, info[a:kind])
endfunction
function! LightlineCocErrors() abort
  return s:lightline_coc_diagnostic('error', 'error')
endfunction
function! LightlineCocWarnings() abort
  return s:lightline_coc_diagnostic('warning', 'warning')
endfunction
function! LightlineCocInfo() abort
  return s:lightline_coc_diagnostic('information', 'info')
endfunction
function! LightlineCocHints() abort
  return s:lightline_coc_diagnostic('hints', 'hint')
endfunction

autocmd User CocDiagnosticChange call lightline#update()

let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ], [ 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'filetype', 'fileencoding', 'fileformat' ] ]
      \ },
      \ 'component_expand': {
      \ 'coc_error': 'LightlineCocErrors',
      \ 'coc_warning': 'LightlineCocWarnings',
      \ 'coc_info': 'LightlineCocInfo',
      \ 'coc_hint': 'LightlineCocHints',
      \ 'coc_fix': 'LightlineCocFixes'
      \ },
      \ 'component_type': {
      \   'coc_error': 'error',
      \   'coc_warning': 'warning',
      \   'coc_info': 'middle',
      \   'coc_hint': 'middle',
      \   'coc_fix': 'middle',
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" === denite.nvim ===
try
  " Interface
  call denite#custom#option('_', {
    \ 'auto_resize': 0,
    \ 'prompt': '❯',
    \ 'max_dynamic_update_candidates': 50000,
    \ 'statusline': 0,
    \ 'split': 'floating',
    \ })

  " Ripgrep for searching filenames, including those in .gitignore`
  call denite#custom#var('file/rec', 'command',
	\ ['rg', '--files', '--glob', '--hidden', '!.git', '--color', 'never'])

  " Git for searching filenames, excluding those in .gitignore`
  call denite#custom#alias('source', 'file/rec/git', 'file/rec')
	call denite#custom#var('file/rec/git', 'command',
	      \ ['git', 'ls-files', '--recurse-submodules', '--cached', '--exclude-standard'])

  " Ripgrep for searching file content
  call denite#custom#var('grep', {
		\ 'command': ['rg'],
		\ 'default_opts': ['-i', '--vimgrep', '--no-heading', '--hidden'],
		\ 'recursive_opts': [],
		\ 'pattern_opt': ['--regexp'],
		\ 'separator': ['--'],
		\ 'final_opts': [],
		\ })

  " Remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')

  " Remove current buffer from buffers list
  call denite#custom#source('buffer', 'matchers',
      \ ['matcher/fuzzy', 'matcher/ignore_current_buffer'])

  " Sort buffer list by most recently accessed
  call denite#custom#source('buffer', 'sorters', ['sorter/oldfiles'])

  " Show relative paths in buffer list
  call denite#custom#source('buffer', 'converters', ['converter/relative_word'])

  " call denite#custom#source('coc-diagnostic', 'converters', ['converter/basename_to_top'])
  " call denite#custom#var('coc-diagnostic', 'abbr', '')


catch
  echo 'denite.nvim not installed. Run :PlugInstall'
endtry

" === ale ===
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_delay = 500
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_sign_column_always = 1
let g:ale_linters = {
\   'cloudformation': ['cloudformation']
\}
