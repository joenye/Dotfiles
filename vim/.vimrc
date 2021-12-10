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

  " Intellisense (auto-completion, linting, fixing)
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Trailing whitespace highlighting & automatic fixing
  Plug 'ntpeters/vim-better-whitespace'

  " Auto-close brackets
  Plug 'jiangmiao/auto-pairs'

  " Return to last place in file upon re-opening
  Plug 'farmergreg/vim-lastplace'

  " Test running
  Plug 'vim-test/vim-test'

  " Nice undo tree
  Plug 'mbbill/undotree'

  " Use <leader>gm to open; then ''o' for older, 'O' for newer, 'q' to close,
  Plug 'rhysd/git-messenger.vim'

  " === Syntax Highlighting === "

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  Plug 'nvim-lua/plenary.nvim'

  " === UI/Menus === "

  " Fuzzy-finding, buffer management
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-web-devicons'

  " fern.vim
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/glyph-palette.vim'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/fern-mapping-project-top.vim'
  Plug 'LumaKernel/fern-mapping-reload-all.vim'
  Plug 'antoinemadec/FixCursorHold.nvim'

  " Theme
  Plug 'ful1e5/onedark.nvim'

  " Status bar
  Plug 'itchyny/lightline.vim'

  " <C-e>
  Plug 'simeji/winresizer'

  Plug 'luukvbaal/stabilize.nvim'
  call plug#end()

catch
  echo 'Vim plug not installed. Attempting to install...'
endtry

" ============================================================================ "
" === MAPPINGS ===
" ============================================================================ "

" Remap leader key to <space>
map <space> <leader>

" Unsets the 'last search pattern' upon return
nnoremap <CR> :noh<CR><CR>

" Always search forward with n and backward with N
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Reverses default behaviour so that j and k move down/up by display lines, while gj and gk move by real lines
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Copy current file path
nnoremap <silent> <leader>c :let @+=expand('%:p')<cr>

" Easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Always shown sign column
set signcolumn=yes

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
set updatetime=300

" === telescope.nvim ===

nnoremap <leader>r <cmd>Telescope find_files<cr>
nnoremap <leader>a <cmd>Telescope live_grep<cr>
nnoremap <leader>t <cmd>Telescope git_files<cr>
nnoremap <leader>z <cmd>Telescope treesitter<cr>
nnoremap <silent>, <cmd>Telescope buffers<cr>

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

" === undotree ===
nnoremap <F4> :UndotreeToggle<cr>

" === vim-test ===
nnoremap <silent> <leader>tn :TestNearest<cr>
nnoremap <silent> <leader>tv :TestNearest -v<cr>
nnoremap <silent> <leader>tl :TestLast<cr>
nnoremap <silent> <leader>tf :TestFile<cr>

" === vim-better-whitespace === "
" Remove all trailing witespace
nmap <silent> <leader>Y :StripWhitespace<CR>

" === coc.nvim ===
" Add `:Format` command to format current buffer
function! s:js_format()
     :CocCommand prettier.formatFile
     :CocCommand eslint.executeAutofix
endfunction
command! -nargs=0 JSFormat :call <SID>js_format()<CR>
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
nmap <leader>f :JSFormat<CR>

" Extension-specific fix action on current item and selection
nmap <silent> <leader>da <Plug>(coc-codeaction)
xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Extension-specific format on selection
vmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

" Jump around code
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gt <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent>K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Rename current word
nmap <leader>dr <Plug>(coc-rename)

" Jump between diagnostics
nmap <silent> <leader>j <Plug>(coc-diagnostic-next)
nmap <silent> <leader>k <Plug>(coc-diagnostic-prev)

" coc-yank list
nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

" Use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ eoc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

augroup CocGroup
	autocmd!
  " Force show signature help on placeholder jump
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


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
set termguicolors
syntax enable

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

" Theme
let g:onedark_comment_style = "italic"
let g:onedark_keyword_style = "NONE"
let g:onedark_function_style = "NONE"
let g:onedark_variable_style = "NONE"
let g:onedark_transparent = 1
colorscheme onedark

" Don't give completion messages like 'match 1 of 2' or 'The only match'
set shortmess+=c

" Preview window appears at bottom
set splitbelow

" Don't display mode in command line (lightline already shows)
set noshowmode

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type

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

" === nvim-treesitter ===
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

" === stabilize.nvim ===
lua require("stabilize").setup()

" === coc.nvim ===
let g:coc_global_extensions = [
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-diagnostic',
  \ 'coc-yank',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-css',
  \ 'coc-pyright',
  \ 'coc-tsserver']

" === git-messenger ===
let g:git_messenger_always_into_popup = 1

" === markdown-preview ===
let g:mkdp_browser = 'firefox'

" === fern.vim ===
let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1
let g:fern#drawer_keep = 1
let g:fern#scheme#file#show_absolute_path_on_root_label = 1

" === lightline.vim ===
let g:lightline_symbol_map = {
  \ 'error': '💩',
  \ 'warning': '⚠️',
  \ 'info': '🔧',
  \ 'hint': '🔧'
  \ }
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
