set tabstop=8
set shiftwidth=8
set colorcolumn=81

" Deoplete
let g:deoplete#sources['c'] = ['clang', 'ultisnips'] + g:deoplete#sources._

" Deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/lib/libclang.so'
let g:deoplete#sources#clang#clang_header= '/lib/clang'
let g:deoplete#sources#clang#sort_algo = 'priority'

" Ale
let g:ale_c_clang_options = '-std=c11 -Wall -Wno-unused-parameter -Wno-missing-braces
                            \ -I/usr/include/pango-1.0
                            \ -I/usr/include/glib-2.0
                            \ -I/usr/lib/glib-2.0/include
                            \ -I/usr/include/cairo'
