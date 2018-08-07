set tabstop=8
set shiftwidth=8

" Deoplete
let g:deoplete#sources['c'] = ['clang', 'ultisnips'] + g:deoplete#sources._

" Deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/lib/libclang.so'
let g:deoplete#sources#clang#clang_header= '/lib/clang'
let g:deoplete#sources#clang#sort_algo = 'priority'
