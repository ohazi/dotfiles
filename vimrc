" From defaults.vim

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=500         " keep command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set wildmenu            " display completion matches in a status line

set ttimeout            " time out for key codes
set ttimeoutlen=100     " wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=lastline

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has("mouse")
  set mouse=a
endif




" Search recursively
set path+=**

" Try to avoid leaving backup files all over the place
set backupdir=~/tmp,.,~/
set backup
set undofile

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

" Re-define *all* of the xterm function key sequences that vim forgets about
" when using tmux. Doing this correctly probably requires an inordinately long
" list, and it seems like you can avoid all this if you just pretend to be
" xterm (see below). The real solution is probably to create a proper terminfo
" for tmux.
" See also: terminalkeys, fixkey plugins
"if &term =~ '^tmux'
"  " Need to enable xterm-keys in tmux
"  execute "set <xUp>=\e[1;*A"
"  execute "set <xDown>=\e[1;*B"
"  execute "set <xRight>=\e[1;*C"
"  execute "set <xLeft>=\e[1;*D"
"endif

" Pretend to be xterm when using tmux
if &term =~ '^tmux' || &term =~ '^screen'
  set title
  if &term =~ '256color'
    set term=xterm-256color
  else
    set term=xterm
  endif
endif

if &term =~ '256color'
  " Use 256 colors
  set t_Co=256
  " Use true colors
  if has("termguicolors")
    set termguicolors
  endif
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Color scheme
set background=dark
try
  " Looks great, but needs a true-color terminal, or annoying changes to the
  " default palette. One of these days I might try to make an almost-seti
  " colorscheme that can work with the default 256-color palette.
  "let base16colorspace=256
  "colorscheme base16-seti

  " Original colors are slightly too warm for my taste.
  "let g:molokai_original=1
  " Rehash is barely noticeable in true-color terminals, but looks better in
  " 256 color terminals with a default palette.
  let g:rehash256=1
  colorscheme molokai
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  " The default colorscheme resets background to light
  set background=dark
endtry




" More stuff from defaults.vim

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif




" From vimrc_example.vim

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
