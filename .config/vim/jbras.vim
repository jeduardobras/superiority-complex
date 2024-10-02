" Enable syntax highlighting
if has("syntax")
    syntax enable
endif

" Set line number
set nu

" Set background and colorscheme
set background=dark
if exists("g:colors_name") && g:colors_name == "dracula"
    colorscheme dracula
else
    " Fallback colorscheme if Dracula is not available
    set t_Co=256
    colorscheme default
endif

" Converts tab into spaces
set expandtab

" Config tab to equal 2 spaces
set tabstop=2 softtabstop=2 shiftwidth=2

" Show number ruler on vim
set number ruler

" Set auto indentation
set autoindent smartindent

