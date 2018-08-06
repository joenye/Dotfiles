set expandtab
set tabstop=4
set shiftwidth=4

" Deoplete
let g:deoplete#sources['c'] = ['clang', 'ultisnips'] + g:deoplete#sources._

" Deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/lib/libclang.so'
let g:deoplete#sources#clang#clang_header= '/lib/clang'
let g:deoplete#sources#clang#sort_algo = 'priority'
