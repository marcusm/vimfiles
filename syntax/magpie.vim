" Vim syntax file
" Language: Magpie
" Maintainer: Marcus Martin
" Latest Revision: 28 October 2010

if exists('b:current_syntax')
    finish
endif

"Keywords
syn keyword magpieBoolen true false
syn keyword magpieStructure class interface nextgroup=magpieFunction skipwhite
syn keyword magpieStatement nothing var it in def shared with
syn keyword magpieStatement new let extend match return this
syn keyword magpieConditional if then else end
syn keyword magpieLabel break case
syn keyword magpieRepeat while do for end
syn keyword magpieFunction fn typeof unsafecast
syn keyword magpieInclude import
syn keyword magpieOperator and or not
syn keyword magpieType Int

syn keyword magpieTodo contained TODO FIXME XXX

" Matches
" Match integers
syn match magpieNumber '\d\+'
syn match magpieNumber '[-+]\d\+'

" Match all the operators
syn match magpieOperator2 '[\-=~\>\<+\.\?\$\&\!\*\/\|]'

" detect special characters in strings
syn match	cSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"

" detect trailing whitespace
syn match	cSpaceError	display excludenl "\s\+$"
 
" Function matching
syn match magpieFunction "^\s*\w+\("me=e-1 contained

" Setup to detect magpie comments
syntax match  magpieCommentSkip	contained "^\s*\*\($\|\s\+\)"
syntax region magpieCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=magpieSpecial,magpieCommentSkip
syntax region magpieComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=magpieSpecial
syntax region magpieCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,magpieComment2String,magpieNumber,magpieSpaceError,@Spell
syntax region magpieComment	matchgroup=magpieCommentStart start="/\*" end="\*/" contains=@cCommentGroup,magpieCommentStartError,magpieCommentString,magpieNumber,magpieSpaceError,@Spell fold extend

" keep a // comment separately, it terminates a preproc. conditional
syntax match magpieCommentError	display "\*/"
syntax match magpieCommentStartError display "/\*"me=e-1 contained


" detect magpie strings
syn region magpieString start=+"+ skip=+\\"+ end=+"+ contains=magpieTodo

" Highlights
hi def link magpieString        String
hi def link magpieCommentString String
hi def link magpieComment2String String
hi def link magpieBoolean       Boolean
hi def link magpieConditional   Conditional
hi def link magpieStatement     Statement
hi def link magpieStructure     Structure
hi def link magpieInclude       Include
hi def link magpieRepeat        Repeat
hi def link magpieFunction      Function
hi def link magpieOperator      Function
hi def link magpieOperator2     Function
hi def link magpieComment       Comment
hi def link magpieCommentL      Comment
hi def link magpieCommentStart  Comment
hi def link magpieLineComment   Comment
hi def link magpieTodo          Todo
hi def link magpieNumber        Number
hi def link magpieType          Type

let b:current_syntax = "magpie"
