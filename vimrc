if has('win32')
    let g:vimfiles_path = fnamemodify($HOME.'/vimfiles', ':p')
    let g:vimrc_path    = fnamemodify($HOME.'/_vimrc', ':p')
else
    let g:vimfiles_path = fnamemodify('~/.vim', ':p')
    let g:vimrc_path    = fnamemodify('~/.vim/.vimrc', ':p')
endif

" This needs to be set prior to loading any plugins
set nocompatible

" Vundle and bundles configuration
"if has('win32')
"    source $HOME/vimfiles/bundles.vim
"else
"    source $HOME/.vim/bundles.vim
"end

" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun! MyGitCheckout(repository, targetDir)
	 let a:repository.url = substitute(a:repository.url, '^git://github', 'https://github', '')
	 return vam#utils#RunShell('git clone --depth=1 $.url $p', a:repository, a:targetDir)
endfun

fun! MyPluginDirFromName(name)
  let dir = vam#DefaultPluginDirFromName(a:name)
  return substitute(dir,'%','_', 'g')
endf

fun! EnsureVamIsOnDisk(plugin_root_dir)
    " windows users may want to use http://mawercer.de/~marc/vam/index.php
    " to fetch VAM, VAM-known-repositories and the listed plugins
    " without having to install curl, 7-zip and git tools first
    " -> BUG [4] (git-less installation)
    let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
    if isdirectory(vam_autoload_dir)
    return 1
    else
    if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
        " I'm sorry having to add this reminder. Eventually it'll pay off.
        call confirm("Remind yourself that most plugins ship with ".
                    \"documentation (README*, doc/*.txt). It is your ".
                    \"first source of knowledge. If you can't find ".
                    \"the info you're looking for in reasonable ".
                    \"time ask maintainers to improve documentation")
        call mkdir(a:plugin_root_dir, 'p')
        execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
                    \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
        " VAM runs helptags automatically when you install or update 
        " plugins
        exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    endif
    return isdirectory(vam_autoload_dir)
    endif
endfun

fun! SetupVAM()
    " Set advanced options like this:
    " let g:vim_addon_manager = {}
    " let g:vim_addon_manager.key = value
    "     Pipe all output into a buffer which gets written to disk
    " let g:vim_addon_manager.log_to_buf =1

    " Example: drop git sources unless git is in PATH. Same plugins can
    " be installed from www.vim.org. Lookup MergeSources to get more control
    " let g:vim_addon_manager.drop_git_sources = !executable('git')
    " let g:vim_addon_manager.debug_activation = 1
    " VAM install location:
    let c = get(g:, 'vim_addon_manager', {'scms': {'git': {}}})
    let g:vim_addon_manager = c
    let g:vim_addon_manager.drop_git_sources = !executable('git')
    " let g:vim_addon_manager.debug_activation = 1
	let g:vim_addon_manager.log_to_buf =1
	let g:vim_addon_manager.auto_install =1
	" let g:vim_addon_manager.shell_commands_run_method = system
	let g:vim_addon_manager.log_buffer_name = expand('$HOME/.vam_log')
	
    let g:vim_addon_manager.scms.git.clone=['MyGitCheckout']
    let g:vim_addon_manager['plugin_dir_by_name'] = 'MyPluginDirFromName'
	
    " let c.plugin_root_dir = expand('$HOME/.vim/vim-addons')
    let c.plugin_root_dir = expand('$HOME/vimfiles/vim-addons')
	
    if !EnsureVamIsOnDisk(c.plugin_root_dir)
        echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
        return
    endif
	
    let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'

    " baseline...utilities required for other plugins
    call vam#ActivateAddons(['sensible','genutils','vim-classpath'], {'auto_install' : 1})
    " improved visuals, no or few commands
    call vam#ActivateAddons(['rainbow_parentheses','vim-airline','Solarized'], {'auto_install' : 1})
    " additional language support
    call vam#ActivateAddons(['go%2854','scss-syntax','vim-clojure-static','vim-fireplace','javascript%2083', 'phpcomplete',], {'auto_install' : 1})
    " web programming
    call vam#ActivateAddons(['css_color','scss-syntax','Emmet'], {'auto_install' : 1})
    " additional commands
    call vam#ActivateAddons(['fugitive','surround', 'Tabular', 'cecscope','The_NERD_Commenter'], {'auto_install' : 1})
    call vam#ActivateAddons(['AutoComplPop', 'L9'], {'auto_install' : 0})
    call vam#ActivateAddons(['neocomplcache','neosnippet'], {'auto_install' : 1})
    " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

    " Addons are put into plugin_root_dir/plugin-name directory
    " unless those directories exist. Then they are activated.
    " Activating means adding addon dirs to rtp and do some additional
    " magic
    
    " useful commands
    " call vam#ActivateAddons(['fugitive', 'Command-T'], {'auto_install' 0 })

    " How to find addon names?
    " - look up source from pool
    " - (<c-x><c-p> complete plugin names):
    " You can use name rewritings to point to sources:
    "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
    "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
    " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]

" my configuration which depends on bundles
set statusline=+'%<\ %f\ %{fugitive#statusline()}'

"-------------------------------------------------------
" Some general environment setup

"Set mapleader
let mapleader = ","
let g:mapleader = ","

set history=500
set spell
set showmode
set bg=dark
colorscheme solarized 

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
    autocmd FileType build,xml,html,c,cs,css,js,javascript,scss,java,perl,shell,bash,cpp,python,vim,php,magpie,go set number

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

let g:SuperTabDefaultCompletionType = "context"

 if exists("g:btm_rainbow_color") && g:btm_rainbow_color
    call rainbow_parenthsis#LoadSquare ()
    call rainbow_parenthsis#LoadRound ()
    call rainbow_parenthsis#Activate ()
 endif

" setup to make sure powerline looks right
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
"set rtp +=~/.vim/bundle/powerline/powerline/bindings/vim/




" setup SuperTab
" let g:SuperTabDefaultCompletionType = "context"

" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
let g:acp_enableAtStartup = 0
" Launches neocomplcache automatically on vim startup.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplcache_min_syntax_length = 3
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder 
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define file-type dependent dictionaries.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword, for minor languages
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion. Not required if they are already set elsewhere in .vimrc
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion, which require computational power and may stall the vim. 
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" Enable airline
" let g:airline_powerline_fonts = 1
