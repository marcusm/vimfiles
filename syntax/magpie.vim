" Vim syntax file
" Language: Magpie
" Maintainer: Marcus Martin
" Latest Revision: 28 October 2010

if exists('b:current_syntax')
    finish
endif

"Keywords
syn keyword magpieStatement true false nothing class var
syn keyword magpieStatement new let
syn keyword magpieClass Nothing Bool Int
syn keyword magpieConditional if then else end
syn keyword magpieRepeat while do for end
syn keyword magpieFunction fn
syn keyword magpieInclude import
syn keyword magpieOperator and or not

syn keyword magpieTodo contained TODO FIXME XXX

" Matches
syn match magpieLineComment "//.*" contains=magpieTodo
syn match magpieNumber '\d\+'
syn match magpieNumber '[-+]\d\+'



" Regions

" Highlights
hi def link magpieConditional   Conditional
hi def link magpieStatement     Statement
hi def link magpieClass         Class
hi def link magpieInclude       Include
hi def link magpieRepeat        Repeat
hi def link magpieFunction      Function
hi def link magpieOperator      Operator
hi def link magpieComment       Comment
hi def link magpieLineComment   Comment
hi def link magpieTodo          Todo
hi def link magpieNumber        Number

let b:current_syntax = "magpie"
