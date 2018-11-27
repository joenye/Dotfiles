set tabstop=8
set shiftwidth=8
set colorcolumn=81

" Deoplete clang_complete
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_omnicppcomplete_compliance = 0
let g:clang_make_default_keymappings = 0

" Ale
let g:ale_c_clang_options = '-std=c11 -Wall -Wno-unused-parameter -Wno-missing-braces
                            \ -I/usr/include/pango-1.0
                            \ -I/usr/include/glib-2.0
                            \ -I/usr/lib/glib-2.0/include
                            \ -I/usr/include/cairo'
