" Variables to modify
" -------------------------------------------

if has('win32')
    let g:vimfiles_path = fnamemodify($HOME.'/vimfiles', ':p')
    let g:vimrc_path    = fnamemodify($HOME.'/_vimrc', ':p')
else
    let g:vimfiles_path = fnamemodify('~/.vim', ':p')
    let g:vimrc_path    = fnamemodify('~/.vim/.vimrc', ':p')
endif

let g:user_name  = "Marcus Martin"
let g:user_email = "nymaen@gmail.com"
let s:baseline_vim_path=""
let g:pythonpath_fixtures= [ g:vimfiles_path . '/python',
              \              g:vimfiles_path . '/after/ftplugin/python/pyflakes' ]

" For overriding these settings or adding sensitive data (such as github
" token):
let s:local_vimrc = fnamemodify('~/.vimrc_local', ':p')

" This needs to be set prior to loading any plugins
set nocompatible

" Setup pathogen before loading any other plugins
filetype off
call pathogen#runtime_append_all_bundles() 
call pathogen#helptags()
filetype on

"-------------------------------------------------------
" Some general environment setup

"Set mapleader
let mapleader = ","
let g:mapleader = ","

set backspace=indent,eol,start
set history=500
set spell
set showmode
colorscheme ingretu 

"cursor colors
highlight cursor        cterm=bold

set cursorline

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

"See tabs and spaces easily
set lcs=tab:>-,trail:_    

" - Don't replace TAB character with only spaces
" - Use a mix of tabs and spaces when I press the TAB key (width 4)
" - Default setting of tabstop (width 4) -- printing, etc
" - Number of spaces to use for each step of indent (width 4)
" - Lines with the same indent level form a fold
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set foldmethod=indent nofoldenable

" set verbosefile=~.vimlog
" set verbose=15
"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

if has("win32")
    " set the font to be consolas
    set guifont=Consolas:h9:cANSI
else
    set guifont=Liberation\ Mono\ 10
endif

"try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk


" set the eformat for SNC for now, will need others
set efm=%f(%l\\,%c):\ %m

" Make command line two lines high
set ch=2

" no toolbar needed
set guioptions-=T


" Allow the cursor to go in to "invalid" places
set virtualedit=all

" treat tag paths as relative
set notagrelative

" ------------------------------------------------
" Setup some helper functions
" ------------------------------------------------

" Force the write of a file with sudo permissions
" if you forgot to sudo vim. Still prompted for
" ths sudo passworf
if has ('unix')
    cmap w!! %!sudo tee > /dev/null %
endif

" Set up retabbing on a source file
nmap  <leader>rr :1,$retab

" cd to the directory containing the file in the buffer
nmap  <leader>cd :lcd %:h

" leader will do a change word
map <leader>w bcw

"Fast reloading of the .vimrc
"map <leader>s :source ~/_vimrc<cr>
"Fast editing of .vimrc
"When .vimrc is edited, reload it
if has("unix")
    map <leader>e :e! ~/.vimrc<cr>
    autocmd! bufwritepost .gvimrc source ~/.gvimrc
else
    map <leader>e :e! ~/_vimrc<cr>
    autocmd! bufwritepost _vimrc source ~/_vimrc
endif         

" ctrl-tab switches to last used buffer
nmap <c-tab> :bu #<cr>
let MRU_Window_Height = 40
let MRU_Max_Entries = 250
map <leader>m :MRU<CR>

map <M-[> :set co=120<CR>:set lines=180<CR>     "fullscreen
map <M-]> :set co=80<CR>:set lines=50<CR>       "minimumscreen
map <M-\> :set co=120<CR>:set lines=80<CR>      "my default screen size 

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>   :update<CR>
vnoremap <C-S>    <C-C>:update<CR>
inoremap <C-S>    <C-O>:update<CR>

" ------------------------------------------------
" Set function keys
" ------------------------------------------------

" F2 to close a buffer file
noremap <silent> <F2> :bd<CR>
vnoremap <silent> <F2> <C-C>:bd<CR>
inoremap <silent> <F2> <C-O>:bd<CR>

" F3to close a buffer file with !
noremap <silent> <F3> :bd!<CR>
vnoremap <silent> <F3> <C-C>:bd!<CR>
inoremap <silent> <F3> <C-O>:bd!<CR>

" To bring up the sidewindow that displays the tags
noremap <silent> <F12> :TlistToggle<CR>
vnoremap <silent> <F12> <C-C>:TlistToggle<CR>
inoremap <silent> <F12> <C-O>:TlistToggle<CR>


" ------------------------------------------------
" Setup backup and swap directory management
" ------------------------------------------------
if !exists("*InitBackupDir")
    function InitBackupDir()
        let separator = "."
        let backup = g:vimfiles_path . separator . 'backup/'
        let tmp    = g:vimfiles_path . separator . 'tmp/'
        
        if exists("*mkdir")
            if !isdirectory(backup)
                call mkdir(backup)
            endif
            if !isdirectory(tmp)
                call mkdir(tmp)
            endif
        endif

        let missing_dir = 0
        if isdirectory(tmp)
            execute 'set backupdir=' . escape(backup, " ") . "/,."
        else
            let missing_dir = 1
        endif

        if isdirectory(backup)
            execute 'set directory=' . escape(tmp, " ") . "/,."
        else
            let missing_dir = 1
        endif
        
        if missing_dir
            echo "Warning: Unable to create backup directories: " 
            . backup ." and " . tmp
            echo "Try: mkdir -p " . backup
            echo "and: mkdir -p " . tmp
            set backupdir=.                 
            set directory=.
        endif
    endfunction        
endif
call InitBackupDir()

" ------------------------------------------------
" Setup specific plugins
" ------------------------------------------------

" surround
let g:surround_indent = 1
let g:surround_{char2nr('i')} = "#if GG\r#endif // GG"


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

" syntax highlighting will work for cpp files in most cases without tags
autocmd Syntax cpp call EnhanceCppSyntax()
" change to directory of current file automatically
" :autocmd BufEnter * lcd %:p:h
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

    " For all text files set 'textwidth' to 100 characters. More comment here.
    autocmd FileType html,text,vim,c,java,xml,bash,magpie,shell,perl,php,python setlocal textwidth=100

    autocmd BufRead,BufNewfile *.build set filetype=xml
    autocmd BufRead,BufNewfile *.mag set filetype=magpie

    " Commenting blocks
    autocmd FileType build,xml,html vmap <C-o> <ESC>'<i<!--<ESC>o<ESC>'>o-->
    autocmd FileType java,c,cpp,cs,php vmap <C-o> <ESC>'<o/*<ESC>'>o*/

    " Flex Development
    au BufNewFile,BufRead *.mxml    		setfiletype mxml
    au BufNewFile,BufRead *.as          	setfiletype actionscript
    
    " Numbering 
    autocmd FileType build,xml,html,c,cs,java,perl,shell,bash,cpp,python,vim,php,magpie set number

    "PHP parser check
    :autocmd FileType php noremap <C-L> :!/usr/bin/php -l %<CR>

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

if has("unix")
    " Support for Pydiction
    let g:pydiction_location = '~/.vim/bundle/pydiction-1.2/ftplugin/pydiction/complete-dict' 

    " Support for pydoc
    let g:pydoc_cmd = "pydoc.py"
else
    " Support for Pydiction
    let g:pydiction_location = 'C:/Users/Marcus Martin/vimfiles/bundle/Pydiction/complete-dict' 

    " Support for pydoc
    let g:pydoc_cmd = "C:/Python27/Lib/pydoc.py"
endif

let g:SuperTabDefaultCompletionType = "context"
