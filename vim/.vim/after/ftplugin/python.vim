set expandtab
set colorcolumn=91
set tabstop=4
set shiftwidth=4
set expandtab

" Syntax
let python_highlight_all = 1 

" YCM
let g:ycm_python_binary_path = '/usr/bin/python'

" Test
let test#python#pytest#executable = 'docker-compose exec app py.test'

" Deoplete
let g:deoplete#sources['python'] = g:deoplete#sources._ + ['ultisnips', 'jedi']

" Deoplete-jedi (https://github.com/zchee/deoplete-jedi)
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#python_path = '/usr/bin/python'
