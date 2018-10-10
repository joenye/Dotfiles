set expandtab
set tabstop=2
set shiftwidth=2
set colorcolumn=

let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions['javascript'] = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]
let g:deoplete#sources['javascript.jsx'] = g:deoplete#sources._ + ['ultisnips', 'ternjs']

" Deoplete-ternjs (https://github.com/carlitux/deoplete-ternjs)
let g:deoplete#sources#ternjs#filetypes = [
  \ 'jsx',
  \ 'javascript.jsx'
\]

" JSX support in JS files
let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1

" autocmd bufwritepost *.js silent !standard --fix %
set autoread
