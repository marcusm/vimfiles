setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent

" Execute file being edited with <Shift> + e:
" map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
if has("unix")
    map <buffer> <S-e> :w<CR>:!python % <CR>
else
    map <buffer> <S-e> :w<CR>:!C:/Python27/Python.exe % <CR>
endif
