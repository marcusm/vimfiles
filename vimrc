" vim: set sw=4 ts=4 sts=4 et tw=78 foldlevel=0 foldmethod=marker spell:
" vimrc
" ----------------------------------------------------------------------------
" License {{{1
" ----------------------------------------------------------------------------
" Copyright 2015 Marcus Martin

" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at

"     http://www.apache.org/licenses/LICENSE-2.0

" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

" ----------------------------------------------------------------------------
" Environment {{{1
" ----------------------------------------------------------------------------
" Identify platform {{{2
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

" Set default shell for mac and windows {{{2
set nocompatible
if !WINDOWS()
    set shell=/bin/sh
endif

" Set environment specific paths for vimfiles and backups {{{2
" All the environment specific paths are created here.
" Swap directories, backup directories, etc.
let g:v = {}
if WINDOWS()
    " let g:plug_threads = 1
    let v.vimfiles_path = fnamemodify($HOME.'/vimfiles', ':p')
    let v.vimrc_path    = fnamemodify($HOME.'/_vimrc', ':p')
    let v.plugin_root_dir = join([v.vimfiles_path, 'bundles'],"/")

    let v.make = ""
else
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
endif

let v.plugin_path = join([v.vimfiles_path, 'autoload/plug.vim'],"/")
let v.cache_dir = join([v.vimfiles_path, '.cache'],"/")
let v.settings_file = join([v.vimfiles_path, 'settings.vim'],"/")

" ----------------------------------------------------------------------------
" Plugin Setup {{{1
" ----------------------------------------------------------------------------
" use vim-plug for my plugins {{{2
silent function! SetupPlug()
if empty(glob('bundles'))
    silent !curl -fLo 'bundles/vim-plug/plug.vim' --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    source bundles/vim-plug/plug.vim
    autocmd VimEnter * PlugInstall
endif
endfunction

" Functions needed for plugin setup {{2
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

" The plugin list {{{2 
call plug#begin(v.plugin_root_dir)
" baseline...utilities required for other plugins {{{3
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neomru.vim'
Plug 'vim-scripts/genutils'
Plug 'xolox/vim-misc'

" improved visuals & colorschemes - no or few commands {{{3
Plug 'amdt/vim-niji'
Plug 'bling/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/syntastic'
Plug 'chriskempson/base16-vim'
Plug 'sjl/badwolf'
Plug 'whatyouhide/vim-gotham'

" clojure language support {{{3
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'tpope/vim-classpath', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }

" GoLang support {{{3
Plug 'nsf/gocode', { 'rtp': 'vim', 'for': 'golang' }

" F# support {{{3
Plug 'marcusm/fsharpbinding', { 'for': 'fsharp' }

" Markdown support {{{3
Plug 'tpope/vim-markdown', {'for': 'markdown'}

" Powershell support {{{3
Plug 'PProvost/vim-ps1', {'for' : 'ps1'}

" TOML support
Plug 'toml-lang/toml'

" Tmux support {{{3
Plug 'christoomey/vim-tmux-navigator'

" web support {{{3
Plug 'mattn/emmet-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'pangloss/vim-javascript'

" local wiki {{{3
Plug 'xolox/vim-notes'

"additional commands {{{3
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-unimpaired'

" alignment assiting plugins {{{3
Plug 'junegunn/vim-easy-align'

" unite does...everything {{{3
Plug 'Shougo/unite.vim', {'do': function('SetupUnite')}

" If not on windows, add you complete me support {{{3
if !WINDOWS()
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
endif

call plug#end()

" Filetype detection, plugins, indent, syntax {{{1
if has('autocmd')
    filetype plugin indent on     " Turn on Filetype detection, plugins, and
                                  " indent
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable         " Turn on syntax highlighting
endif
  
" ----------------------------------------------------------------------------
" Moving around, searching and patterns {{{1
" ----------------------------------------------------------------------------
set nostartofline     " keep cursor in same column for long-range motion cmds
set incsearch         " Highlight pattern matches as you type
set ignorecase        " ignore case when using a search pattern
set smartcase         " override 'ignorecase' when pattern has upper case
                      " character

set whichwrap+=<,>,h,l "Backspace and cursor keys wrap to

" Disable arrow keys
map  <up>    <nop>
map  <down>  <nop>
map  <left>  <nop>
map  <right> <nop>
imap <up>    <nop>
imap <down>  <nop>
imap <left>  <nop>
imap <right> <nop>

" ----------------------------------------------------------------------------
"  Tags {{{1
" ----------------------------------------------------------------------------
set notagrelative

" ----------------------------------------------------------------------------
"  Displaying text {{{1
" ----------------------------------------------------------------------------
set scrolloff=3       " number of screen lines to show around the cursor

set linebreak         " For lines longer than the window, wrap intelligently.
                      " This doesn't insert hard line breaks.

set sidescrolloff=2   " min # of columns to keep left/right of cursor
set display+=lastline " show last line, even if it doesn't fit in the window

set cmdheight=2       " # of lines for the command window
                      " cmdheight=2 helps avoid 'Press ENTER...' prompts

" Display unprintable chars
set list
" set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣
let &showbreak = '↳ '

set number            " show line numbers

set lz                " do not redraw while running macros (LazyRedraw)

" ----------------------------------------------------------------------------
"  Syntax, highlighting and spelling {{{1
"  ----------------------------------------------------------------------------
set background=dark

" ignore colorscheme doesn't exist error if isn't installed
silent! colorscheme gotham256

if exists('+colorcolumn')
    set colorcolumn=80    " display a line in column 80 to show you
                          " where to line break.
endif

set spell

"cursor colors
highlight cursor        cterm=bold
set cursorline

" ----------------------------------------------------------------------------
"  Multiple windows {{{1
" ----------------------------------------------------------------------------
set laststatus=2      " Show a status line, even if there's only one
                      " Vim window

set hidden            " allow switching away from current buffer w/o writing

set switchbuf=usetab  " Jump to the 1st open window which contains
                      " specified buffer, even if the buffer is in
                      " another tab.

set statusline=
set statusline+=b%-1.3n\ >                    " buffer number
set statusline+=\ %{fugitive#statusline()}:
set statusline+=\ %F
set statusline+=\ %M
set statusline+=%R
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%=
set statusline+=\ %Y
set statusline+=\ <\ %{&fenc}
set statusline+=\ <\ %{&ff}
set statusline+=\ <\ %p%%
set statusline+=\ %l:
set statusline+=%02.3c   " cursor line/total lines

set helpheight=30        " Set window height when opening Vim help windows

" Fix some iTerm junk
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

" ----------------------------------------------------------------------------
"  Multiple tab pages {{{1
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  Terminal {{{1
" ----------------------------------------------------------------------------
set ttyfast			      " this is the 21st century, people

" ----------------------------------------------------------------------------
"  Using the mouse {{{1
" ----------------------------------------------------------------------------
set mousemodel=extend
set mouse=a

" ----------------------------------------------------------------------------
"  GUI {{{1			     
"  Set these options in .gvimrc
" See help for 'setting-guifont' for tips on how to set guifont on Mac vs Windows
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  Printing {{{1
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  Messages and info {{{1
" ----------------------------------------------------------------------------
set showcmd         " In the status bar, show incomplete commands
                    " as they are typed

set noshowmode      " don't display the current mode (Insert, Visual, Replace)
                    " in the status line. This info is already shown in the
                    " Airline status bar.

set ruler           " Always display the current cursor position in
                    " the Status Bar

set confirm         " Ask to save buffer instead of failing when executing
                    " commands which close buffers

set noerrorbells    " No sound on errors.
set novisualbell

set shm+=I          " No start up message

" ----------------------------------------------------------------------------
"  Selecting text {{{1
" ----------------------------------------------------------------------------
set clipboard=unnamed	" Yank to the system clipboard by default

set go+=a " visual selection will yank to clipboard

" ----------------------------------------------------------------------------
"  Editing text {{{1
" ----------------------------------------------------------------------------
set backspace=indent,eol,start  "backspace over everything

set formatoptions+=j      " delete comment char on second line when
                          " joining two commented lines

set showmatch             " when inserting a bracket, briefly jump to its
                          " match

set nojoinspaces          " Use only one space after '.' when joining
                          " lines, instead of two

set completeopt+=longest,menuone  " better omni-complete menu

set nrformats-=octal      " don't treat numbers with leading zeros as octal
                          " when incrementing/decrementing

" ----------------------------------------------------------------------------
"  Tabs and indenting {{{1
" ----------------------------------------------------------------------------
set tabstop=4             " tab = 4 spaces
set shiftwidth=4          " autoindent indents 4 spaces
set smarttab              " <TAB> in front of line inserts 'shiftwidth' blanks
set softtabstop=4
set shiftround            " round to 'shiftwidth' for "<<" and ">>"
set expandtab

" ----------------------------------------------------------------------------
"  Folding {{{1
" ----------------------------------------------------------------------------
if has('folding')
  set foldmethod=indent nofoldenable
endif

" ----------------------------------------------------------------------------
"  Diff mode {{{1
" ----------------------------------------------------------------------------
set diffopt+=horizontal   " start diff mode with horizontal splits by default

" ----------------------------------------------------------------------------
"  Mapping {{{1
" ----------------------------------------------------------------------------
"Set mapleader {{{2
let mapleader = ","
let g:mapleader = ","

"try to make possible to navigate within lines of wrapped lines {{{2
nmap <Down> gj
nmap <Up> gk

" Set up retabbing on a source file {{{2
nmap  <leader>rr :1,$retab

" cd to the directory containing the file in the buffer {{{2
nmap  <leader>cd :lcd %:h

"Fast editing of .vimrc {{{2
map <leader>e :e! $MYVIMRC<cr>

"When .vimrc is edited, reload it {{{2
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" ctrl-tab switches to last used buffer {{{2
nmap <c-tab> :bu #<cr>
let MRU_Window_Height = 40
let MRU_Max_Entries = 250

" Use CTRL-S for saving, also in Insert mode
noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" try to remap esc key
map  <Help>   <Esc>
map! <Help>   <Esc>
map  <Insert> <Esc>
map! <Insert> <Esc>

" backspace in Visual mode deletes selection
vnoremap <BS> d

" ----------------------------------------------------------------------------
"  Reading and writing files {{{1
" ----------------------------------------------------------------------------
set autoread             " Automatically re-read files changed outside
                         " of Vim

" ----------------------------------------------------------------------------
"  The swap file {{{1
" ----------------------------------------------------------------------------

" Set swap file, backup and undo directories to sensible locations
" Taken from https://github.com/tpope/vim-sensible
" The trailing double '//' on the filenames cause Vim to create undo, backup,
" and swap filenames using the full path to the file, substituting '%' for
" '/', e.g. '%Users%bob%foo.txt'
let s:dir = has('win32') ? '$APPDATA/Vim' : match(system('uname'), "Darwin") > -1 ? '~/Library/Vim' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'

let common_dir = expand(s:dir) .'/'
if !isdirectory(common_dir)
    call mkdir(common_dir)
endif

let dir_list = {
            \ 'backup' : 'backupdir',
            \ 'swap' : 'directory',
            \ 'views' : 'viewdir',
            \ 'undo' : 'undodir' }

for [dirname, settingname] in items(dir_list)
  let directory = common_dir . dirname . '/'
  if exists("*mkdir")
    if !isdirectory(directory)
      call mkdir(directory)
    endif
  endif
  if !isdirectory(directory)
    echo "Warning: Unable to create backup directory: " . directory
    echo "Try: mkdir -p " . directory
    else
    let directory = substitute(directory, " ", "\\\\ ", "g")
    exec "set " . settingname . "=" . directory
  endif
endfor

if exists('+undofile')
  set undofile
endif

" ----------------------------------------------------------------------------
"  Command line editing {{{1
" ----------------------------------------------------------------------------
set history=200    " Save more commands in history
                   " See Practical Vim, by Drew Neil, pg 68

set wildmode=list:longest,full

" File tab completion ignores these file patterns
" Mac files/dirs
if match(system('uname'), "Darwin") > -1
  set wildignore+=.CFUserTextEncoding,
        \*/.Trash/*,
        \*/Applications/*,
        \*/Library/*,
        \*/Movies/*,
        \*/Music/*,
        \*/Pictures/*,
        \.DS_Store
endif

" ignore binary files
set wildignore+=*.exe,*.png,*.jpg,*.gif,*.doc,*.mov,*.xls,*.msi
" Vim files
set wildignore+=*.sw?,*.bak,tags
" Chef
set wildignore+=*/.chef/checksums/*

set wildmenu

" Add guard around 'wildignorecase' to prevent terminal vim error
if exists('&wildignorecase')
  set wildignorecase
endif

set shellslash
" ----------------------------------------------------------------------------
"  Executing external commands {{{1
" ----------------------------------------------------------------------------

if has("win32") || has("gui_win32")
  if executable("PowerShell")
    " Set PowerShell as the shell for running external ! commands
    " http://stackoverflow.com/questions/7605917/system-with-powershell-in-vim
    set shell=PowerShell
    set shellcmdflag=-ExecutionPolicy\ RemoteSigned\ -Command
    set shellquote=\"
    " shellxquote must be a literal space character.
    set shellxquote= 
  endif
endif

" ----------------------------------------------------------------------------
"  Running make and jumping to errors {{{1
" ----------------------------------------------------------------------------

if executable('grep')
  set grepprg=grep\ --line-number\ -rIH\ --exclude-dir=tmp\ --exclude-dir=.git\ --exclude=tags\ $*\ /dev/null
endif

" ----------------------------------------------------------------------------
"  Language specific {{{1
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  Multi-byte characters {{{1
" ----------------------------------------------------------------------------
set encoding=utf-8
scriptencoding utf-8


" ----------------------------------------------------------------------------
"  Various {{{1
" ----------------------------------------------------------------------------
" Don't save global options. These should be set in vimrc {{{2
" Idea from tpope/vim-sensible
set sessionoptions-=options   

" Allow the cursor to go in to "invalid" places {{{2
set virtualedit=all
" ----------------------------------------------------------------------------
" Autocmds {{{1
" ----------------------------------------------------------------------------
" When editing a file, always jump to the last known cursor position. {{{2
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
" From https://github.com/thoughtbot/dotfiles/blob/master/vimrc
autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Enable omni completion. {{{2
autocmd FileType css,less setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Use the below to highlight trailing whitespace. {{{2
" Don't do it for unite windows or readonly files
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
    augroup MyAutoCmd
    autocmd BufWinEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
    autocmd InsertEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
    autocmd InsertLeave * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
    autocmd BufWinLeave * if &modifiable && &ft!='unite' | call clearmatches() | endif
augroup END

autocmd BufRead,BufNewfile *.build set filetype=xml
autocmd BufRead,BufNewfile *.mag set filetype=magpie

" ----------------------------------------------------------------------------
" Allow overriding these settings {{{1
" ----------------------------------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
"-------------------------------------------------------

" Force the write of a file with sudo permissions
" if you forgot to sudo vim. Still prompted for
" ths sudo password
if has ('unix')
    cmap w!! %!sudo tee > /dev/null %
endif

