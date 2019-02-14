" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2014 Nov 05
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc


" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Check if curl command is installed as it used to install things on vim
if !executable("curl") 
  silent !sudo apt-get install curl
endif

" **********************************************************************
" BEGIN PLUG-INS
" **********************************************************************
" vim-plug a plugin manager for vim 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vim/vimrc
endif

" All my vim plugins
call plug#begin('./my_plugins')

" Theme to replace the crap theme vim has
Plug 'drewtempelmeyer/palenight.vim'

" Fuzzy Finder for vim
Plug 'junegunn/fzf.vim'

" A theme for the line at the bottom of a vim editor
Plug 'itchyny/lightline.vim'

" Multiple cursor editing in vim
Plug 'terryma/vim-multiple-cursors'

" Bracket completion in vim
Plug 'tpope/vim-surround'

" Show changes in git in left gutter
Plug 'airblade/vim-gitgutter'

" Emmet code completion - Shorthand HTML, CSS, JS
Plug 'mattn/emmet-vim'

" Add a tree file view in vim
Plug 'scrooloose/nerdtree'

" End of the vim plugins
call plug#end()
" **********************************************************************
" END PLUG-INS
" **********************************************************************

" Set syntax highlight for isl and def files
au BufRead,BufNewFile *.Isl set filetype=xml | call SyntaxRange#Include('<js>','</js>','javascript')
au BufRead,BufNewFile *.def set filetype=xml

" Add line numbers
set number

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Configurations for lightline
set laststatus=2
set noshowmode

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set background=dark
  colorscheme palenight
  set hlsearch
endif


" enable auto indenting
set autoindent
" enable smart indenting
set smartindent
" amount of spaces per tab
set tabstop=2
set shiftwidth=2
" make all tabs into spaces
set expandtab
set softtabstop=0

" Set a line down the screen to indicate columns that are too long
set colorcolumn=120

" Set vimdiff to ignore white space
set diffopt+=iwhite
