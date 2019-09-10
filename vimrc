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

" Themes to replace the default vim theme
Plug 'drewtempelmeyer/palenight.vim'
Plug 'chriskempson/base16-vim'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'crusoexia/vim-monokai'
" Added support for onedark
Plug 'sheerun/vim-polyglot'

" Auto complete support in vim
Plug 'Valloric/YouCompleteMe'

" Fuzzy Finder for vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Prettier
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" A theme for the line at the bottom of a vim editor
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


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

" Emoji Support in vim!!!
Plug 'junegunn/vim-emoji'

" ALE for ESLint support in vim
Plug 'dense-analysis/ale'

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


" Configurations for airline
let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  " set mouse=a
endif

if (&term == "pcterm" || &term == "win32")
  set term=xterm t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
  set termencoding=utf8
endif
                                                        
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  colorscheme palenight
  " set background=dark
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

" Set the current line to be highlighted
set cursorline

" Line break options to auto indent on line breaks and break at words
set linebreak

" Set vimdiff to ignore white space
" set diffopt+=iwhite



" Emoji auto-complete/search functionality i.e. 😃 
set completefunc=emoji#complete

" Open up userf files
command! Userf :tabedit ~/aleks_zap/current/aleks/src/IslUserf/src/userf.def
command! UserfChem :tabedit ~/aleks_zap/current/aleks/src/IslUserf/src/userfChemistry.def


" Run Prettier on save
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

" Highlight closing and ending jsx tags differently
let g:vim_jsx_pretty_highlight_close_tag = 1
" Allow jsx in all js files
let g:jsx_ext_required = 0

" Use prettier and eslint for ale fixing files
let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
" Fix JS files automatically on save
let g:ale_fix_on_save = 1
" Use nice emojis for ale
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
" Bindings for movement with ale errors
nmap <silent> [c <Plug>(ale_previous_wrap)
nmap <silent> ]c <Plug>(ale_next_wrap)










let g:fileJSEnd = "_structure_data"
function! GetItemPath()
  return substitute(expand("%:p:r"),"\\([A-Za-z]\\+\\d\\{3\\}\\)\.\\+\$", "\\1", "")
:endfunction
function! PathJS()
  return GetItemPath().g:fileJSEnd.".js"
:endfunction
function! PathIsl()
  return GetItemPath().".Isl"
:endfunction

function! OpenJS()
  execute "vsplit ".PathJS()
:endfunction
function! OpenIsl()
  execute "vsplit ".PathIsl()
:endfunction

function! CreateJS()
  call system("touch ".PathJS())
:endfunction

function! FindTagsJS()
  " Find the first set of js tags
  execute "normal! gg/<js>\<Enter>"
:endfunction

function! ExportJS()
  " Open the Isl file if we are not currently on it
  let inIslFile = 1
  if PathIsl() != expand("%:p")
    call OpenIsl()
    let inIslFile = 0
  endif
  " Go to the first set of JS tags
  call FindTagsJS()
  " Make sure the js tags are folded in order to delete them easily 
  let currlinenum = line(".")
  if foldclosed(currlinenum) < 0
    execute "normal! zfat"
  endif
  " Add all the text between the JS Tag to the current buffer
  execute "normal! Y"
  " Quit the Isl file if we weren't previously in it
  if inIslFile == 0
    execute "q"
  endif

  " Open the JS file in a new split view
  call OpenJS()
  " Go to the top of the file and then delete all lines of the file
  " and don't add the deleted lines to the register
  execute "normal! gg\"_dG"
  " Paste and remove extra space up top, extra tag up top and extra
  " tag at the bottom
  execute "normal! pggd2dGdd"
  " Indent entire file down one
  execute "%<"
  " Write and quit the open split
  execute "wq"

:endfunction

function! ImportJS(...)
  " Open the Isl file if we are not currently on it
  let inIslFile = 1
  if PathIsl() != expand("%:p")
    call OpenIsl()
    let inIslFile = 0
  endif

  " Find the function @userfOrgaChem.loadDataFile and add a line below it
  execute "normal! gg/@userfOrgaChem.loadDataFile\<Enter>"
  let functionLine = line(".")
  let a:lineNum = get(a:, 1, functionLine)
  " Append the lines of js to line 2 in the file
  let jslines = ["<js>"] + readfile(PathJS()) + ["</js>"]
  call append(a:lineNum, jslines)
  " Fix indenting in JS
  call FindTagsJS()
  execute "normal! vit><<"
  " Fold the JS lines
  execute "normal! zfat"
  " Save the file to view changes in ZAP"
  execute "w"

  " If we weren't in the Isl file to start with then close it
  if inIslFile == 0 
    execute "q"
  endif
:endfunction

command! ImportJS :call ImportJS()
command! ExportJS :call ExportJS()
command! CreateJS :call CreateJS()

" Search for CSS colors with a few rules for Isl:
"   Make sure hex colors aren't preceded with an '&' because those are most
"   likely html entities
"   Make sure color names don't start with '@userf.' nor '@' because those are color
"   variables
"   Make sure color names don't start with 'name=' because that is a variable
"   declaration
command! SearchColor :%s/\c\v%(\&)@<!#([A-Fa-f0-9]{3}){1,2}|<((\@(userf.)?|name\=)@<!(AliceBlue|AntiqueWhite|Aqua(marine)?|Azure|Beige|Bisque|BlanchedAlmond|Blue|BlueViolet|Brown|BurlyWood|CadetBlue|Chartreuse|Chocolate|Coral|CornflowerBlue|Cornsilk|Crimson|Cyan|DarkBlue|DarkCyan|DarkGoldenRod|DarkGray|DarkGrey|DarkGreen|DarkKhaki|DarkMagenta|DarkOliveGreen|DarkOrange|DarkOrchid|DarkRed|DarkSalmon|DarkSeaGreen|DarkSlateBlue|DarkSlateGray|DarkSlateGrey|DarkTurquoise|DarkViolet|DeepPink|DeepSkyBlue|DimGray|DimGrey|DodgerBlue|FireBrick|FloralWhite|ForestGreen|Fuchsia|Gainsboro|GhostWhite|Gold(enRod)?|Gray|Grey|Green|GreenYellow|HoneyDew|HotPink|IndianRed|Indigo|Ivory|Khaki|Lavender(Blush)?|LawnGreen|LemonChiffon|LightBlue|LightCoral|LightCyan|LightGoldenRodYellow|LightGray|LightGrey|LightGreen|LightPink|LightSalmon|LightSeaGreen|LightSkyBlue|LightSlateGray|LightSlateGrey|LightSteelBlue|LightYellow|Lime|LimeGreen|Linen|Magenta|Maroon|MediumAquaMarine|MediumBlue|MediumOrchid|MediumPurple|MediumSeaGreen|MediumSlateBlue|MediumSpringGreen|MediumTurquoise|MediumVioletRed|MidnightBlue|MintCream|MistyRose|Moccasin|NavajoWhite|Navy|OldLace|Olive(Drab)?|Orange|OrangeRed|Orchid|PaleGoldenRod|PaleGreen|PaleTurquoise|PaleVioletRed|PapayaWhip|PeachPuff|Peru|Pink|Plum|PowderBlue|Purple|RebeccaPurple|Red|RosyBrown|RoyalBlue|SaddleBrown|Salmon|SandyBrown|SeaGreen|SeaShell|Sienna|Silver|SkyBlue|SlateBlue|SlateGray|SlateGrey|Snow|SpringGreen|SteelBlue|Tan|Teal|Thistle|Tomato|Turquoise|Violet|Wheat|WhiteSmoke|YellowGreen|Yellow))>//gn

function! ReplaceColor(searchColor,replaceColor)
  if a:searchColor =~ "\#"
    execute "%s/\\c\\v(\\&)@<!".a:searchColor."/".a:replaceColor."/g"
    echom "Hex"
  else
    execute "%s/\\c\\v(\\@(userf.)?|name\\=)@<!<".a:searchColor.">/".a:replaceColor."/g"
    echom "Color"
  endif
:endfunction
command! -nargs=+ ReplaceColor :call ReplaceColor(<f-args>)
