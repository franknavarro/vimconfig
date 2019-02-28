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
call plug#begin('~/.vim/my_plugins')

" Theme to replace the crap theme vim has
Plug 'drewtempelmeyer/palenight.vim'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'crusoexia/vim-monokai'
" Added support for onedark
Plug 'sheerun/vim-polyglot'

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

" Dependency for SyntaxRange
Plug 'inkarkat/vim-ingo-library'

" Add support for changing highlighting between tags
Plug 'inkarkat/vim-SyntaxRange'

" End of the vim plugins
call plug#end()
" **********************************************************************
" END PLUG-INS
" **********************************************************************

" Set syntax highlight for isl and def files
filetype plugin on 
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
  " set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  colorscheme onedark
  set background=dark
  set hlsearch
endif

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screens
  set t_ut=
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
" set diffopt+=iwhite

" Open vimrc from anywhere in vim
map <leader>vimrc :tabe ~/.vim/vimrc<Enter>
" Re-compile vimrc when it is saved
" autocmd BufWritePost vimrc source ~/.vim/vimrc

" if &diff == 'nodiff'
" set shellcmdflag=-ic
" endif

function! PathJS()
  return expand("%:p:r")."_structure_data.js"
:endfunction

function! OpenJS()
  execute "vsplit ".PathJS()
:endfunction

function! CreateJS()
  system("touch ".PathJS())
:endfunction

function! FindTagsJS()
  " Find the first set of js tags
  execute "normal! gg/<js>\<Enter>"
:endfunction

function! ExportJS()
  call FindTagsJS()
  " Make sure the js tags aren't folded and if they are unfold them
  let currlinenum = line(".")
  
  if foldclosed(currlinenum) > 0
    execute "normal! za"
  endif
  " Select all the text between the first JS tags
  execute "normal! vit"
  " Get the path of the current file
  let filename = PathJS() 
  
  " Check if the file is already open in the buffer
  let buffername = bufname(filename)
  
  execute "'<,'>w! ".filename
  execute "normal! ddd"
  let windownum = bufwinnr(filename)
  
  " File is not already opened
  if windownum < 0 
    " Copy all the text to a new file
    call OpenJS()
    execute "normal! ggdd"
    execute "%<"
    execute "wq"
  else
    " File already opened
  endif
:endfunction

function! ImportJS(...)
  let a:lineNum = get(a:, 1, 1)
  " Append the lines of js to line 2 in the file
  let jslines = ["<js>"] + readfile(PathJS()) + ["</js>"]
  call append(a:lineNum, jslines)
  " Fix indenting in JS
  call FindTagsJS()
  execute "normal! vit><<"
  " Fold the JS lines
  execute "normal! zfat"
:endfunction








