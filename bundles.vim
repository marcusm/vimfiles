set nocompatible               " be iMproved
filetype off                   " required!

let vundleAlreadyExists=1
let vundle_readme=expand('$VIM/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    if isdirectory(expand('$VIM/bundle')) == 0
        call mkdir(expand('$VIM/bundle'), 'p')
    endif
    execute 'silent !git clone https://github.com/gmarik/vundle "' . expand('$VIM/bundle/vundle') . '"'
    let vundleAlreadyExists=0
endif

set rtp+=$VIM/bundle/vundle/
call vundle#rc('$VIM/bundle')


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
