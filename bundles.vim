set nocompatible               " be iMproved
filetype off                   " required!

let vundleAlreadyExists=1
let vundle_readme=expand(g:vimfiles_path . 'bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    if isdirectory(expand(g:vimfiles_path . 'bundle')) == 0
        call mkdir(expand(g:vimfiles_path . 'bundle'), 'p')
    endif
    execute 'silent !git clone https://github.com/gmarik/vundle "' . expand(g:vimfiles_path . 'bundle/vundle') . '"'
    let vundleAlreadyExists=0
endif

if has('win32') || has('win64')
  set rtp+=$HOME/vimfiles/bundle/vundle/
else
  set rtp+=$HOME/.vim/bundle/vundle/
endif

call vundle#rc(g:vimfiles_path . 'bundle')


Bundle 'gmarik/vundle'

" git usability
Bundle 'tpope/vim-fugitive'

" movements
Bundle 'Command-T'
Bundle 'python_match.vim'

" useful commands
Bundle 'The-NERD-Commenter'
Bundle 'Tabular'
Bundle 'Indent-Guides'
Bundle 'git://github.com/tpope/vim-sensible.git'
Bundle 'git://github.com/Lokaltog/powerline.git'
Bundle 'Rainbow-Parenthsis-Bundle'
Bundle 'surround.vim'

" clojure
Bundle 'git://github.com/tpope/vim-classpath.git'
Bundle 'git://github.com/tpope/vim-foreplay.git'
Bundle 'git://github.com/guns/vim-clojure-static.git'

" syntax
Bundle 'Syntastic'

" snippets
Bundle 'SuperTab'
Bundle 'UltiSnips'

" colors
Bundle 'Solarized'



filetype plugin indent on     " required!

set rtp +=~/.vim/bundle/powerline/powerline/bindings/vim/
