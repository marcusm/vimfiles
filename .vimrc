 filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles() 
filetype on

set nocompatible

set backspace=indent,eol,start
set history=500
set spell
set showmode
colorscheme ir_black
"cursor colors
highlight cursor        cterm=bold

set cursorline

"See tabs and spaces easily
set lcs=tab:>-,trail:_    


if has("unix")
    set guifont=Liberation\ Mono\ 10
else
    " set the font to be consolas
    set guifont=Consolas:h9:cANSI
endif

"mapping for command key to map navigation thru display lines instead
"of just numbered lines
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

"try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk


" That is:
" - Don't replace TAB character with only spaces
" - Use a mix of tabs and spaces when I press the TAB key (width 4)
" - Default setting of tabstop (width 4) -- printing, etc
" - Number of spaces to use for each step of indent (width 4)
" - Lines with the same indent level form a fold   set noexpandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set foldmethod=indent nofoldenable
" Fix up indent issues - I can't stand wasting an indent because I'm in a
" namespace.  If you don't like this then just comment this line out.

setlocal indentexpr=GetCppIndentNoNamespace(v:lnum)

" set the eformat for SNC for now, will need others
set efm=%f(%l\\,%c):\ %m

if !exists('*CFile')                       
    function CFile(filename)
        return(cfile filename)
    endfunction
endif
	
"
" GetCppIndentNoNamespace()
"
" This little function calculates the indent level for C++ and treats the
" namespace differently than usual - we ignore it.  The indent level is the for
" a given line is the same as it would be were the namespace not event there.
"
function! GetCppIndentNoNamespace(lnum)
    let nsLineNum = search('^\s*\<namespace\>\s\+\S\+', 'bnW')
    if nsLineNum == 0
        return cindent(a:lnum)
    else
        let inBlockComment = 0
        let inLineComment = 0
        let inCode = 0
        for n in range(nsLineNum + 1, a:lnum - 1)
            if IsBlockComment(n)
                let inBlockComment = 1
            elseif IsBlockEndComment(n)
                let inBlockComment = 0
            elseif IsLineComment(n) && inBlockComment == 0
                let inLineComment = 1
            elseif IsCode(n) && inBlockComment == 0
                let inCode = 1
                break
            endif
        endfor
        if inCode == 1
            return cindent(a:lnum)
        elseif inBlockComment
            return cindent(a:lnum)
        elseif inLineComment
            if IsCode(a:lnum)
                return cindent(nsLineNum)
            else
                return cindent(a:ln
            endif
        elseif inBlockComment == 0 && inLineComment == 0 && inCode == 0
            return cindent(nsLineNum)
        endif
    endif
endfunction


set mousemodel=extend

set autoread
set shellslash
set ruler
set showcmd
set incsearch
set showmatch
set hidden 
set mouse=a
set hlsearch
set smarttab
set cindent
set autoindent
set smartcase   " Turn off ignorecase in a typed search if an uppercase char exists.
set ignorecase  " Turn off ignorecase in a typed search if an uppercase char exists.
set shm+=I      " No start up message
set guioptions+=a
set lz " do not redraw while running macros (much faster) (LazyRedraw)
set go+=a " visual selection will yank to clipboard

"No sound on errors.
set noerrorbells
set novisualbell
set t_vb=

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

set foldopen=all	" opens a line that's folded if I move on to it

ab #d #define
ab #i #include

" let g:p4Presets = 'tibP4Proxy.tib.ad.ea.com:2000 mamartin TIBURON-DOMAIN\mamartin, tibStudio.tib.ad.ea.com:1666 mamartin TIBURON-DOMAIN\mamartin, tibFootball.tib.ad.ea.com:1666 mamartin_Madden12 TIBURON-DOMAIN\mamartin'
" let  g:p4DefaultPreset = 2 " default to the first entry in the p4Presets list
 
" Make command line two lines high
set ch=2
" no toolbar needed
set guioptions-=T
" visual bell
set vb

" Set up retabbing on a source file
nmap  ,rr :1,$retab

" cd to the directory containing the file in the buffer
nmap  ,cd :lcd %:h

" Allow the cursor to go in to "invalid" places
set virtualedit=all

" treat tag paths as relative
set notagrelative
" To bring up the sidewindow that displays the tags
noremap <silent> <F12> :TlistToggle<CR>
vnoremap <silent> <F12> <C-C>:TlistToggle<CR>
inoremap <silent> <F12> <C-O>:TlistToggle<CR>
" Which tag file to load:
"set tags=c:/p4/ssxv/wf2/TAGS
"                                                                    
set tags=tags;/ 
"let &tags=string(tagspath . "/TAGS;/")
"set tags=string('d:/perforce/eac-p4basekit/wf/ml/TAGS') 
"set tags=tags;/ 
"set updatetime=2000

" F2 to close a buffer file
noremap <silent> <F2> :bd<CR>
vnoremap <silent> <F2> <C-C>:bd<CR>
inoremap <silent> <F2> <C-O>:bd<CR>

" F93to close a buffer file with !
noremap <silent> <F3> :bd!<CR>
vnoremap <silent> <F3> <C-C>:bd!<CR>
inoremap <silent> <F3> <C-O>:bd!<CR>

" surround
let g:surround_indent = 1
let g:surround_{char2nr('i')} = "#if GG\r#endif // GG"

" map Ctrl-A, Ctrl-E, and Ctrl-K in *all* modes. map! makes the mapping work in
" insert and commandline modes too.
map  <C-A> <Home>
map  <C-E> <End>
map  <C-K> J
map! <C-A> <Home>
map! <C-E> <End>
imap <C-K> <Esc>Ji

"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Fast reloading of the .vimrc
"map <leader>s :source ~/_vimrc<cr>
"Fast editing of .vimrc
"When .vimrc is edited, reload it
if has("unix")
    map <leader>e :e! ~/.vimrc<cr>
    autocmd! bufwritepost .vimrc source ~/.vimrc
else
    map <leader>e :e! ~/_vimrc<cr>
    autocmd! bufwritepost _vimrc source ~/_vimrc
endif

" leader will do a change word
map <leader>w bcw

" make the cursor behave differently in different modes
"highlight Cursor   guifg=white  guibg=magenta
"highlight iCursor  guifg=white  guibg=steelblue
"set guicursor=n-v-c:block-Cursor
"set guicursor+=i:ver100-iCursor
"set guicursor+=n-v-c:blinkon0-Cursor
"set guicursor+=i:blinkwait20-iCursor 


if has("unix")
    set backupdir=$HOME//.vim//backups//
    set dir=$HOME//.vim//swaps//
else
    set backupdir=$HOME//vimfiles//backups//
    set dir=$HOME//vimfiles//swaps//
endif

" scan the drives on the machine and create aliases to them for CD_Plus
let g:CD_scan_pc_drives = 1

" ********************************************************************
" MiniBufExplorer
" use Control + VIM direction keys to move around in MiniBufExplorer

" pretend it's loaded already, this way we can leave this code here and leave
" th plugin there, but not use it
"let loaded_minibufexplorer = 1
let g:miniBufExplMapWindowNavVim = 1
" single click on tabs
let g:miniBufExplUseSingleClick = 0
let g:miniBufExplVSplit = 30   " column width in chars 
"map <up> :MBEbp<RETURN> " up arrow (normal mode) switches buffers  (excluding minibuf) 
"map <down> :MBEbn<RETURN> " down arrow (normal mode) switches buffers (excluding minibuf)

map _ :bd!<cr>

"map <Leader>b :MiniBufExplorer<cr>
"hi MBENormal         guifg=blue
"hi MBEChanged        guifg=red
"hi MBEVisibleNormal  guibg=black guifg=white
"hi MBEVisibleChanged guibg=red guifg=white
" ********************************************************************

" ctrl-tab switches to last used buffer
nmap <c-tab> :bu #<cr>
let MRU_Window_Height = 40
let MRU_Max_Entries = 250
map <leader>m :MRU<CR>

" change to directory of current file automatically
:autocmd BufEnter * lcd %:p:h

map <M-[> :set co=120<CR>:set lines=180<CR>     "fullscreen
map <M-]> :set co=80<CR>:set lines=50<CR>       "minimumscreen
map <M-\> :set co=120<CR>:set lines=80<CR>      "my default screen size 

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>   :update<CR>
vnoremap <C-S>    <C-C>:update<CR>
inoremap <C-S>    <C-O>:update<CR>

" backspace in Visual mode deletes selection
vnoremap <BS> d

let g:showmarks_include="abcdefghijklmnopqrstuvwxyz"

set wildmenu
set wildmode=list:longest,full 

syntax on

set laststatus=2


" Add highlighting for function definition in C++
function! EnhanceCppSyntax()
  syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
  hi def link cppFuncDef Special
endfunction

autocmd Syntax cpp call EnhanceCppSyntax()

"if has("cscope")
	"" add the path of ur cscope binary here in this location
"		set csprg=d:/home/jskelton/bin/cscope.exe
"		set csto=0
"		set cst
"		set nocsverb
"		set csverb
"        
"		function CScope_Refresh()
"			cs kill 0
"			!find $PWD -name \*.[ch] > files && cscope -b -i files
"			cs add cscope.out
"		endfunction

"           's'   symbol: find all references to the token under cursor
"           'g'   global: find global definition(s) of the token under cursor
"           'c'   calls:  find all calls to the function name under cursor
"           't'   text:   find all instances of the text under cursor
"           'e'   egrep:  egrep search for the word under cursor
"           'f'   file:   open the filename under cursor
"           'i'   includes: find files that include the filename under cursor
"           'd'   called: find functions that function under cursor calls
"         <C-]> is mapped to :cs find g implicitly
		
"		map <C-[> :cs find s <C-R>=expand("<cword>")<CR><CR>
"		map <C-\> :cs find c <C-R>=expand("<cword>")<CR><CR>
"		imap <C-\> :cs find c <C-R>=expand("<cword>")<CR><CR>
"		map <C-_> :cs find t <C-R>=expand("<cword>")<CR><CR>
"		imap <C-_> :cs find t <C-R>=expand("<cword>")<CR><CR>
"		map <C-E> :cs find e <C-R>=expand("<cword>")<CR><CR>
"		map <C-I> :cs find f <C-R>=expand("<cword>")<CR><CR>

"         Commands to shorten "cs find ..." things
"		comm! -nargs=1 S :cs find s <args>
"		comm! -nargs=1 C :cs find c <args>
"		comm! -nargs=1 T :cs find t <args>
"		comm! -nargs=1 E :cs find e <args>
"		comm! -nargs=1 F :cs find f <args>
"		comm! -nargs=1 G :cs find g <args>
"		comm! -nargs=1 L :cs load <args>
"		comm! -nargs=0 D :cs show
"		comm! -nargs=0 K :cs kill 0
"		comm! -nargs=0 A :cs add cscope.out
"		comm! -nargs=0 R call CScope_Refresh()
"endif

"this mapping assigns a variable to be the name of the function found by
"FunctionName() then echoes it back so it isn't erased if Vim shifts your
"location on screen returning to the line you started from in FunctionName()
"map \func :let name = FunctionName()<CR> :echo name<CR> 


"tip # 1066
function! AddEmptyLineBelow()
    call append(line("."), "")
endfunction

function! AddEmptyLineAbove()
    let l:scrolloffsave = &scrolloff
    " Avoid jerky scrolling with ^E at top
    " of window
    set scrolloff=0
    call append(line(".") - 1, "")
    if winline() != winheight(0)
        silent normal! ^E
    end
    let &scrolloff = l:scrolloffsave
endfunction

function! DelEmptyLineBelow()
    if line(".") == line("$")

        return
    end
    let l:line = getline(line(".") + 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .+1d
        ''
        call cursor(line("."), l:colsave)
    end
endfunction

function! DelEmptyLineAbove()
    if line(".") == 1
        return
    end
    let l:line = getline(line(".") - 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .-1d
silent normal! ^Y
        call cursor(line("."), l:colsave)
    end
endfunction

noremap <silent> <C-j> :call AddEmptyLineBelow()<CR>
noremap <silent> <C-k> :call DelEmptyLineBelow()<CR>
noremap <silent> <A-j> :call DelEmptyLineAbove()<CR>
noremap <silent> <A-k> :call AddEmptyLineAbove()<CR> 



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do this part when compiled with support for autocommands.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
    " Get RCS ready.
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    autocmd BufRead,BufNewfile *.py syntax on
    autocmd BufRead,BufNewfile *.py set ai

    autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType html,text,php,vim,c,java,xml,bash,shell,perl,python setlocal textwidth=100

    " XML Tag autocompletion.  Used in conjunction with closetag. 
    " TODO: Find out how to avoid the unnamed register.
    "  autocmd Filetype html,xml,xsl source $VIMRUNTIME/plugin/closetag.vim

    autocmd BufRead,BufNewfile *.build set filetype=xml

    " Commenting blocks
    autocmd FileType build,xml,html vmap <C-o> <ESC>'<i<!--<ESC>o<ESC>'>o-->
    autocmd FileType java,c,cpp,cs vmap <C-o> <ESC>'<o/*<ESC>'>o*/

    " Numbering 
    autocmd FileType build,xml,html,c,cs,java,perl,shell,bash,cpp,python,vim,php set number

    " From Bram:
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " DF - Also do not do this if the file resides in the $TEMP directory,
    "      chances are it is a different file with the same name.
    " This comes from the $VIMRUNTIME/vimrc_example.vim file
    autocmd BufReadPost *
    \ if expand("<afile>:p:h") !=? $TEMP |
    \   if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g`\"" |
    \     let b:doopenfold = 1 |
    \   endif |
    \ endif
    " Need to postpone using "zv" until after reading the modelines.
    autocmd BufWinEnter *
    \ if exists("b:doopenfold") |
    \   unlet b:doopenfold |
    \   exe "normal zv" |
    \ endif 
endif " has("autocmd")  


" ***********************************************************************
" http://www.vim.org/tips/tip.php?tip_id=1386
" make autocompletion a bit more friendly to use
" The first step to "improve" the menu behavior is to execute this command:
:set completeopt=longest,menuone

"The above command will change the 'completeopt' option so that Vim's popup menu doesn't select the first completion item, but rather just inserts the longest common text of all matches; and the menu will come up even if there's only one match. (The longest setting is responsible for the former effect and the menuone is responsible for the latter.) 

:inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>" 
:inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
:inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>" 

" ***********************************************************************

" tear off buffer
":tearoff Buffers
"autocmd VimEnter * tearoff Buffers
"let g:bmenu_max_pathlen=0


map __ :buffers<BAR>
			\let i = input("Buffer number: ")<BAR>
			\execute "buffer " . i<CR> 



let g:clj_highlight_builtins = 1
let g:clj_highlight_contrib = 1
let g:clj_paren_rainbow = 1
let g:clj_want_gorilla = 1

" For Scons
au BufNewFile,BufRead SCons* set filetype=scons

if has("unix")
    " Support for Pydiction
    let g:pydiction_location = '~/.vim/bundle/pydiction-1.2/ftplugin/pydiction/complete-dict' 

    " Support for pydoc
    let g:pydoc_cmd = "pydoc.py"
else
    " Support for Pydiction
    let g:pydiction_location = 'C:/Users/Marcus Martin/vimfiles/bundle/pydiction-1.2/ftplugin/pydiction/complete-dict' 

    " Support for pydoc
    let g:pydoc_cmd = "C:/Python25/Lib/pydoc.py"
endif
