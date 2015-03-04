" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on
scriptencoding utf-8
set encoding=utf-8

let g:v = {}

if has('win32') || has('win64')
    " let g:plug_threads = 1
    let v.is_win = 1
    let v.vimfiles_path = fnamemodify($HOME.'/vimfiles', ':p')
    let v.vimrc_path    = fnamemodify($HOME.'/_vimrc', ':p')
    let v.plugin_root_dir = join([v.vimfiles_path, 'bundles'],"/")

    let &backupdir = join([expand($HOME), 'vimfiles', 'backup'],"/")
    let &directory = join([expand($HOME), 'vimfiles', 'swap'],"/")
    let v.make = ""
else
    let v.is_win = 0
    if has('nvim')
        let v.vim_resource_path = ".nvim"
        let v.vimrc_file_name = ".nvimrc"
    else
        let v.vim_resource_path  = ".vim"
        let v.vimrc_file_name = ".vimrc"
    endif

    let v.vimfiles_path = join([expand($HOME), v.vim_resource_path],"/")
    let v.vimrc_path = join([expand($HOME), v.vim_resource_path, v.vimrc_file_name],"/")
    let v.plugin_root_dir = join([expand($HOME), v.vim_resource_path, 'bundles'],"/")

    let &backupdir = join([expand($HOME), v.vim_resource_path, 'backup'],"/")
    let &directory = join([expand($HOME), v.vim_resource_path, 'swap'],"/")
endif

let v.plugin_path = join([v.vimfiles_path, 'autoload/plug.vim'],"/")
let v.cache_dir = join([v.vimfiles_path, '.cache'],"/")


" use vim-plug for my plugins
if empty(glob(v.plugin_root_dir))
  silent !curl -fLo v.plugin_path --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall
        endif

" Functions needed for plugin setup
function! SetupUnite(info)
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
    call unite#custom#source('files_rec/async','line,outline','matchers','matcher_fuzzy')
    call unite#custom#profile('default', 'context', {
      \ 'start_insert': 1,
      \ 'direction': 'botright',
      \ })
endfunction

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  "   " - name:   name of the plugin
  "     " - status: 'installed', 'updated', or 'unchanged'
  "       " - force:  set on PlugInstall! or PlugUpdate!
  let g:ycm_filetype_blacklist={'unite': 1}

  if a:info.status == 'installed' || a:info.force
     !./install.sh
  endif
endfunction


call plug#begin(v.plugin_root_dir)
" baseline...utilities required for other plugins
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neomru.vim'
Plug 'vim-scripts/genutils'
Plug 'xolox/vim-misc'

" improved visuals, no or few commands
Plug 'amdt/vim-niji'
Plug 'bling/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/syntastic'
Plug 'chriskempson/base16-vim'
Plug 'sjl/badwolf'
Plug 'whatyouhide/vim-gotham'

" clojure language support
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'tpope/vim-classpath', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }

" GoLang support
Plug 'nsf/gocode', { 'rtp': 'vim', 'for': 'golang' }

" F# support
Plug 'kongo2002/fsharp-vim', { 'for': 'fsharp' }

" Nim support
Plug 'zah/nimrod.vim'

" Powershell support
Plug 'PProvost/vim-ps1', {'for' : 'ps1'}

" Tmux support
Plug 'christoomey/vim-tmux-navigator'

" web support
Plug 'mattn/emmet-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'pangloss/vim-javascript'

" local wiki
Plug 'xolox/vim-notes'

"additional commands
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-unimpaired'


Plug 'junegunn/vim-easy-align'

Plug 'Shougo/unite.vim', {'do': function('SetupUnite')}

if v.is_win == 0
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
endif

call plug#end()

" my configuration which depends on bundles
set statusline=+'%<\ %f\ %{fugitive#statusline()}'

"-------------------------------------------------------
" Some general environment setup

"Set mapleader
let mapleader = ","
let g:mapleader = ","

let loaded_matchparen = 1
set spell
set history=500
set showmode
set bg=dark
colorscheme badwolf

"cursor colors
highlight cursor        cterm=bold

set cursorline

set mousemodel=extend
set shellslash
set hidden 
set mouse=a
set hlsearch
set cindent
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

" Display unprintable chars
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣
let &showbreak = '↳ '

" listchar=te
" trail is not as flexible, use the below to highlight trailing
" whitespace. Don't do it for unite windows or readonly files
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
    augroup MyAutoCmd
    autocmd BufWinEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
    autocmd InsertEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
    autocmd InsertLeave * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
    autocmd BufWinLeave * if &modifiable && &ft!='unite' | call clearmatches() | endif
augroup END

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
    "set guifont=Liberation\ Mono\ 10
    set guifont=Source\ Code\ Pro\ for\ Powerline:h12
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
" Setup some helper functions for Go
" ------------------------------------------------
function! s:GoVet()
    cexpr system("go vet " . shellescape(expand('%')))
    copen
endfunction
command! GoVet :call s:GoVet()


function! s:GoLint()
    cexpr system("golint " . shellescape(expand('%')))
    copen
endfunction
command! GoLint :call s:GoLint()

" Force the write of a file with sudo permissions
" if you forgot to sudo vim. Still prompted for
" ths sudo password
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
" map <leader>s :source $MYVIMRC<cr>
"Fast editing of .vimrc
"When .vimrc is edited, reload it
 map <leader>e :e! $MYVIMRC<cr>
 autocmd! bufwritepost $MYVIMRC source $MYVIMRC

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
    autocmd FileType html,text,vim,c,java,xml,bash,magpie,shell,perl,php,python,go setlocal textwidth=100

    autocmd BufRead,BufNewfile *.build set filetype=xml
    autocmd BufRead,BufNewfile *.mag set filetype=magpie

    " Commenting blocks
    autocmd FileType build,xml,html vmap <C-o> <ESC>'<i<!--<ESC>o<ESC>'>o-->
    autocmd FileType java,c,cpp,cs,php vmap <C-o> <ESC>'<o/*<ESC>'>o*/

    " Numbering 
    autocmd FileType build,bash,c,clojure,cpp,cs,css,go,html,java,javascript,js,magpie,perl,php,python,scss,shell,vim,xml,zsh set number

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
set completeopt=longest,menuone

"The above command will change the 'completeopt' option so that Vim's popup menu doesn't select the first completion item, but rather just inserts the longest common text of all matches; and the menu will come up even if there's only one match. (The longest setting is responsible for the former effect and the menuone is responsible for the latter.) 

" ***********************************************************************

" rainbow paren settings
let g:niji_matching_filetypes = ['lisp', 'ruby', 'python', 'clojure', 'javascript', 'js', 'csharp', 'vimscript']

" Enable omni completion. Not required if they are already set elsewhere in .vimrc
autocmd FileType css,less setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable airline
if !has('win32')
    let g:airline_powerline_fonts = 1
endif

" Setup vim-notes
:let g:notes_directories = ['~/Documents/Notes', '~/Dropbox/Shared Notes']

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" try to remap esc key
map <Help> <Esc>
map! <Help> <Esc>
map <Insert> <Esc>
map! <Insert> <Esc>

" Disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" unite setup
let g:unite_data_directory=join([v.cache_dir, 'unite'])
let g:unite_source_history_yank_enable=1
let g:unite_source_rec_max_cache_files=5000

if executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
    let g:unite_source_grep_command='ack'
    let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
    let g:unite_source_grep_recursive_opt=''
endif

function! s:unite_settings()
    nmap <buffer> Q <plug>(unite_exit)
    nmap <buffer> <esc> <plug>(unite_exit)
    imap <buffer> <esc> <plug>(unite_exit)
endfunction

autocmd FileType unite call s:unite_settings()

nmap <space> [unite]
nnoremap [unite] <nop>

if v.is_win
    nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec:! buffer file_mru bookmark<cr><c-u>
    nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec:!<cr><c-u>
else
    nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr><c-u>
    nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
endif
nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>


" Fix som iTerm junk
if $TERM_PROGRAM == 'iTerm.app'
    " different cursors for insert vs normal mode
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
endif

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
