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
  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

  " Trailing whitespace highlighting & automatic fixing
  Plug 'ntpeters/vim-better-whitespace'

  " Auto-close brackets plugin
  Plug 'rstacruz/vim-closer'

  " Return to last place in file upon re-opening
  Plug 'farmergreg/vim-lastplace'

  " Print method signatures in echo area
  Plug 'Shougo/echodoc.vim'

  " Test running
  Plug 'janko-m/vim-test'

  " HTML Abbreviations expansion
  Plug 'mattn/emmet-vim'

  " Switch into tmux easily
  Plug 'christoomey/vim-tmux-navigator'

  " cxiw and .
  Plug 'tommcdo/vim-exchange'

  " nvim terminal wrapper
  Plug 'kassio/neoterm'

  " Highlight matching characters
  Plug 'RRethy/vim-illuminate'

  " Always highlight XML/HTML tags
  Plug 'Valloric/MatchTagAlways'

  " Nice undo tree
  Plug 'mbbill/undotree'

  " :GV git browser
  Plug 'junegunn/gv.vim'

  " Markdown syntax
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

  " Snippets
  Plug 'SirVer/ultisnips'
  Plug 'joenye/vim-snippets'

  " Generate JSDoc based on signature
  Plug 'heavenshell/vim-jsdoc'

  " Good when sharing screen
  Plug 'junegunn/goyo.vim'

  " === Syntax Highlighting === "

  " Python
  Plug 'hdima/python-syntax'

  " Markdown
  Plug 'gabrielelana/vim-markdown'

  " nginx
  Plug 'chr4/nginx.vim'

  " Javascript
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'othree/yajs.vim'

  " React JSX
  Plug 'mxw/vim-jsx'

  " Typescript
  Plug 'HerringtonDarkholme/yats.vim'

  " HTML5
  Plug 'othree/html5.vim'

  " JSON
  Plug 'elzr/vim-json'

  " === UI/Menus === "

  " Fuzzy-finding, buffer management
  Plug 'Shougo/denite.nvim'

  " NERDTree
  Plug 'scrooloose/nerdtree'
  Plug 'tpope/vim-vinegar'

  " Theme
  Plug 'ryanoasis/vim-devicons'
  Plug 'rakr/vim-one'

  " Status bar
  Plug 'itchyny/lightline.vim'

  " <C-e>
  Plug 'simeji/winresizer'

  call plug#end()

catch
  echo 'Vim plug not installed. Attempting to install...'
endtry

" ============================================================================ "
" ===                           MAPPINGS                                   === "
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
map <c-a> <esc>ggVG<cr>

" === nerdtree ===
map <C-n> :NERDTreeFind<CR>

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
\    },
\}

" === vim-better-whitespace === "
" Remove all trailing whitespace
nmap <leader>y :StripWhitespace<CR>

" === coc.nvim ===
let g:coc_global_extensions = ['coc-eslint', 'coc-json', 'coc-css', 'coc-python', 'coc-tsserver']

" Extension-specific fix action on current item and selection
nmap <silent> <leader>da <Plug>(coc-codeaction)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Extension-specific format on selection
xmap <leader>f  <Plug>(coc-format-selected)
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
"   ,         - Browser currently open buffers (not using ; since that repeats f-search
"   <leader>r - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>t - Search current directory for occurences of word under cursor
nmap , :Denite buffer -split=floating -winrow=1<CR>
nmap <leader>r :Denite file/rec -split=floating -winrow=1<CR>
try
  nmap <leader>a :Denite grep:::! -split=floating -winrow=1<CR>
  gnoremap <leader>g :<C-u>Denite grep:. -no-empty -mode=normal -split=floating -winrow=1<CR>
  nnoremap <leader>t :<C-u>DeniteCursorWord grep:. -mode=normal -split=floating -winrow=1<CR>
catch
endtry

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
set cursorline

" Close vim if NERDTree is only thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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

" ============================================================================ "
" ===                           UI/MENU OPTIONS                            === "
" ============================================================================ "

" Enable true color support
if has('nvim')
  set termguicolors
endif
syntax enable

" Add custom highlights in method that is executed every time a colorscheme is sourced
" See https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
" and https://github.com/junegunn/goyo.vim/issues/84
function! MyHighlights() abort
  " Hightlight trailing whitespace
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

" Customize NERDTree directory
hi! NERDTreeCWD guifg=#99c794

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

" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

" == vim-markdown ===
let g:markdown_enable_spell_checking = 0

" == vim-devicons ===
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" === echodoc.vim ===
let g:echodoc#enable_at_startup = 1

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

" === vim-markdown ===
let g:markdown_enable_spell_checking = 0

" === nerdtree ===
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeIgnore = ['\.pyc$', '^__pycache__$', '\.sw.$', '\.un\~', '^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
let g:NERDTreeMapQuit = 'qq'
let g:NERDTreeStatusline = ''
let NERDTreeChDirMode=2
let g:NERDTreeDirArrowExpandable = '├'
let g:NERDTreeDirArrowCollapsible = '└'

" === vim-illuminate ===
let g:Illuminate_ftblacklist = ['nerdtree']

" === vim-test ===
let test#strategy = 'neoterm'
let g:neoterm_size = '15'
let g:neoterm_autoscroll = 1
let g:neoterm_autoinsert = 1
let g:neoterm_default_mod = ':botright'
let g:test#preserve_screen = 1

" === vim-devicons ===
" https://github.com/ryanoasis/vim-devicons/issues/154
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

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
  " Uses ripgrep for searching current directory for files
  " By default, ripgrep will respect rules in .gitignore
  "   --files: Print each file that would be searched (but don't search)
  "   --glob:  Include or exclues files for searching that match the given glob
  "            (aka ignore .git files)
  "
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

  " Custom options for ripgrep (mostly defaults according to Denite docs)
  "   --vimgrep:  Show results with every match on it's own line
  "   --hidden:   Search hidden directories and files
  "   --heading:  Show the file name above clusters of matches from each file
  "   --S:        Search case insensitively if the pattern is all lowercase
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

  " Recommended defaults according to Denite docs
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])

  " Remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')

  call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

  " Custom options for Denite
  "   auto_resize             - Auto resize the Denite window height automatically
  "   prompt                  - Customize denite prompt
  "   direction               - Specify Denite window direction as directly below current pane
  "   winminheight            - Specify min height for Denite window
  "   highlight_mode_insert   - Specify h1-CursorLine in insert mode
  "   prompt_highlight        - Specify color of prompt
  "   highlight_matched_char  - Matched characters highlight
  "   highlight_matched_range - matched range highlight
  let s:denite_options = {'default' : {
  \ 'auto_resize': 1,
  \ 'prompt': 'λ:',
  \ 'direction': 'rightbelow',
  \ 'winminheight': '10',
  \ 'highlight_mode_insert': 'Visual',
  \ 'highlight_mode_normal': 'Visual',
  \ 'prompt_highlight': 'Function',
  \ 'highlight_matched_char': 'Function',
  \ 'highlight_matched_range': 'Normal'
  \ }}

  " Loop through denite options and enable them
  function! s:profile(opts) abort
    for l:fname in keys(a:opts)
      for l:dopt in keys(a:opts[l:fname])
        call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      endfor
    endfor
  endfunction

  call s:profile(s:denite_options)
catch
  echo 'denite.nvim not installed. Run :PlugInstall'
endtry

" ============================================================================ "
" ===                           MISC                                       === "
" ============================================================================ "

" TODO: Replace when wl-protocols stabilise and are actually used:
" https://github.com/neovim/neovim/issues/9213
" let g:clipboard = {
" \   'name': 'wl-clipboard',
" \   'copy': {
" \      '+': 'wl-copy --foreground',
" \      '*': 'wl-copy --foreground --primary',
" \    },
" \   'paste': {
" \      '+': 'wl-paste --no-newline',
" \      '*': 'wl-paste --no-newline --primary',
" \   },
" \   'cache_enabled': 1,
" \ }

" Detect CloudFormation templates
function! SetCfn()
  set ft=cloudformation
  set syn=yaml
endfunction
autocmd BufRead,BufNewFile *.yaml if getline(1) =~ 'AWSTemplateFormatVersion' | :call SetCfn() | endif
autocmd BufRead,BufNewFile *.yaml if getline(2) =~ 'AWSTemplateFormatVersion' | :call SetCfn() | endif
autocmd BufRead,BufNewFile *.yaml if match(readfile(@%), 'AWS::') | :call SetCfn() | endif

