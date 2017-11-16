" Expected behavior from the example vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want
source $VIMRUNTIME/defaults.vim




" Search recursively
set path+=**

" Try to avoid leaving backup files all over the place
set backupdir=~/tmp,.,~/
set backup

" It's tempting to do something similar with swap files, but they're less
" annoying, and I don't really want to worry about filename collisions.

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Scroll sideways in small increments
set sidescroll=10

" Scrolling off near the top or bottom is extremely annoying
set scrolloff=0

" Play nicely with system clipboard
set clipboard^=unnamed,unnamedplus

" Line wrapping
set nowrap

" Line numbering
set number
set relativenumber

" Line highlighting
set cursorline
"set cursorcolumn

" Spell checking
set spell

" Use true colors
set termguicolors

" Color scheme
set background=dark
colorscheme base16-seti

" Re-define *all* of the xterm function key sequences that vim forgets about
" when using tmux. Doing this correctly probably requires an inordinately long
" list, and it seems like you can avoid all this if you just pretend to be
" xterm (see below). The real solution is probably to create a proper terminfo
" for tmux.
"if &term =~ '^tmux'
"  " Need to enable xterm-keys in tmux
"  execute "set <xUp>=\e[1;*A"
"  execute "set <xDown>=\e[1;*B"
"  execute "set <xRight>=\e[1;*C"
"  execute "set <xLeft>=\e[1;*D"
"endif

" Pretend to be xterm when using tmux
if &term =~ '^tmux' || &term =~ '^screen'
  " Already set above 
  "set background=dark
  set title
  if &term =~ '256color'
    set term=xterm-256color
    set t_Co=256
  else
    set term=xterm
  endif
endif




" More stuff from the example vimrc

" Highlight search results
if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  augroup END
else
  set autoindent " always set autoindenting on
endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif
