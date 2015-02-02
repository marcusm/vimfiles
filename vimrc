" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

let g:v = {}
let v.is_nvim = strridx($VIM,"nvim")

if (v.is_nvim > 0)
    let v.vim_resource_path = ".nvim"
    let v.vimrc_file_name = ".vimrc"
else
    let v.vim_resource_path  = ".vim"
    let v.vimrc_file_name = ".vimrc"
endif

if has('win32')
    let v.vimfiles_path = fnamemodify($HOME.'/vimfiles', ':p')
    let v.vimrc_path    = fnamemodify($HOME.'/_vimrc', ':p')
    let v.plugin_root_dir = join([v.vimfiles_path, 'vim-addons'],"/")
else
    let v.vimfiles_path = join([expand($HOME), v.vim_resource_path],"/")
    let v.vimrc_path = join([expand($HOME), v.vim_resource_path, v.vimrc_file_name],"/")
    let v.plugin_root_dir = join([expand($HOME), v.vim_resource_path, 'vim-addons'],"/")

    let &backupdir = join([expand($HOME), v.vim_resource_path, 'backup'],"/")
    let &directory = join([expand($HOME), v.vim_resource_path, 'swap'],"/")
endif

let v.vam_log_file = join([expand($HOME), v.vim_resource_path, 'vam.log'],"/")

" This needs to be set prior to loading any plugins
set nocompatible

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

fun! SetupVAM(vim_config)
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
    "let g:vim_addon_manager.debug_activation = 1
    let g:vim_addon_manager.log_to_buf =1
	let g:vim_addon_manager.auto_install =1
	"let g:vim_addon_manager.shell_commands_run_method = system
	let g:vim_addon_manager.log_buffer_name = a:vim_config.vam_log_file
	
    let g:vim_addon_manager.scms.git.clone=['MyGitCheckout']
    let g:vim_addon_manager['plugin_dir_by_name'] = 'MyPluginDirFromName'

    let c.plugin_root_dir = a:vim_config.plugin_root_dir
"    let c.plugin_root_dir = expand('$HOME/vimfiles/vim-addons')
	
    if !EnsureVamIsOnDisk(c.plugin_root_dir)
        echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
        return
    endif
	
    let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'

    " baseline...utilities required for other plugins
    call vam#ActivateAddons(['sensible','genutils','vim-classpath','repeat','dispatch','cecscope'], {'auto_install' : 1})
    " improved visuals, no or few commands
    call vam#ActivateAddons(['vim-niji','vim-airline','Solarized','Indent_Guides'], {'auto_install' : 1})
    " GoLang support
    call vam#ActivateAddons(['github:/Blackrush/vim-gocode'], {'auto_install' : 1})
    " Fsharp support
    call vam#ActivateAddons(['github:kongo2002/fsharp-vim.git'], {'auto_install' : 1})
    " web programming
    call vam#ActivateAddons(['scss-syntax','Emmet','javascript%2083'], {'auto_install' : 1})
    " clojure language support
    call vam#ActivateAddons(['vim-clojure-static','vim-fireplace','github:tpope/vim-leiningen.git','vim-sexp','github:tpope/vim-sexp-mappings-for-regular-people.git','github:guns/vim-clojure-highlight.git'], {'auto_install' : 1})
    " vim utilit
    call vam#ActivateAddons(['github:christoomey/vim-tmux-navigator.git'], {'auto_install' : 1})
    " additional commands
    call vam#ActivateAddons(['Syntastic','fugitive','surround','vim-easy-align'], {'auto_install' : 1})
    call vam#ActivateAddons(['commentary','github:/ctrlpvim/ctrlp.vim'], {'auto_install' : 1})
    call vam#ActivateAddons(['abolish','matchit.zip'], {'auto_install' : 1})
    call vam#ActivateAddons(['YouCompleteMe'], {'auto_install' : 1})


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
call SetupVAM(v)
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

set spell
set history=500
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
:set completeopt=longest,menuone

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

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" try to remap esc key
map <Help> <Esc>
map! <Help> <Esc>
map <Insert> <Esc>
map! <Insert> <Esc>
