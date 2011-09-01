call pathogen#runtime_append_all_bundles()

" Disable Generation of Backup Files
" ----------------------------------
"  actually they are nice but vim is stable and doesn't crash :D
set nobackup
set noswapfile


" Some File Type Stuff
" --------------------
"  Enable filetype plugins and disable indentation
syntax on
filetype on
filetype plugin on
filetype indent off


" Proper line breaking / word wrapping
" ------------------------------------
" Enable a proper word wrapping
set formatoptions=l
set lbr


" Leader
" ------
" sets leader to ',' and localleader to "\"
let mapleader=","
let maplocalleader="\\"


" User Interface
" --------------
" activate wildmenu, permanent ruler and disable Toolbar, and add line
" highlightng as well as numbers.
" also highlight current line and disable the blinking r.
set guioptions-=T
set gcr=a:blinkon0
set ruler
set nocursorline
set wildmenu


" Set Better Indention
" --------------------
"  go with smartindent if there is no plugin indent file.
"  but don't outdent hashes
set smartindent
inoremap # X#

" indent comments correctly?
set fo+=c

set backspace=indent,eol,start
" set textwidth=120

" Statusbar and Linenumbers
" -------------------------
"  Make the command line two lines heigh and change the statusline display to
"  something that looks useful.
set cmdheight=2
set laststatus=2
set showcmd
set number

" To emulate the standard status line with 'ruler' set, use this:
"
"   set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"

runtime /home/ente/.vim/plugin/pythonhelper.vim
if !exists("*TagInStatusLine")
  function TagInStatusLine()
    return ''
  endfunction
endif
if !exists("*haslocaldir")
  function! HasLocalDir()
    return ''
  endfunction
else
  function! HasLocalDir()
    if haslocaldir()
      return '[lcd]'
    endif
    return ''
  endfunction
endif

set statusline=			" my status line contains:
set statusline+=%n:		" - buffer number, followed by a colon
set statusline+=%<%f		" - relative filename, truncated from the left
set statusline+=\ 		" - a space
set statusline+=%h		" - [Help] if this is a help buffer
set statusline+=%m		" - [+] if modified, [-] if not modifiable
set statusline+=%r		" - [RO] if readonly
set statusline+=\ 		" - a space
set statusline+=%1*%{TagInStatusLine()}%*	" [current class/function]
set statusline+=\ 		" - a space
set statusline+=%=		" - right-align the rest
set statusline+=%-10.(%l,%c%V%) " - line,column[-virtual column]
set statusline+=\ 		" - a space
set statusline+=%4L		" - total number of lines in buffer
set statusline+=\ 		" - a space
set statusline+=%P		" - position in buffer as percentage




" Tab Settings
" ------------
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4


" utf-8 default encoding
" ----------------------
set enc=utf-8

" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart

" python support
" --------------
"  don't highlight exceptions and builtins. I love to override them in local
"  scopes and it sucks ass if it's highlighted then. And for exceptions I
"  don't really want to have different colors for my own exceptions ;-)
"
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 omnifunc=pythoncomplete#Complete
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

" LessCSS Support
" ---------------
au BufNewFile,BufRead *.less set filetype=less
autocmd FileType less setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Scss Support
" ------------
au BufNewFile,BufRead *.scss set filetype=scss
autocmd FileType scss setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2


" C/C++ Support
" -----------
autocmd FileType cpp setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 omnifunc=ccomplete#Complete


" C# Support
" ----------
autocmd FileType cs setlocal shiftwidth=8 tabstop=8 softtabstop=8

" CoffeeScript Support
" --------------------
au BufNewFile,BufRead *.coffee set filetype=less
autocmd FileType coffee setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Inyoka Syntax Support
" ---------------------
au BufRead,BufNewFile *.uu set filetype=inyoka

" template language support (SGML / XML too)
" ------------------------------------------
" and disable taht stupid html rendering (like making stuff bold etc)

fun! s:SelectHTML()
let n = 1
while n < 50 && n < line("$")
  " check for jinja
  if getline(n) =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
    set ft=htmljinja
    return
  endif
  " check for django
  if getline(n) =~ '{%\s*\(extends\|block\|comment\|ssi\|if\|for\|blocktrans\)\>'
    set ft=htmldjango
    return
  endif
  " check for mako
    if getline(n) =~ '<%\(def\|inherit\)'
      set ft=mako
      return
    endif
    " check for genshi
    if getline(n) =~ 'xmlns:py\|py:\(match\|for\|if\|def\|strip\|xmlns\)'
      set ft=genshi
      return
    endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun

autocmd FileType html,xhtml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd BufNewFile,BufRead *.rhtml setlocal ft=eruby
autocmd BufNewFile,BufRead *.mako setlocal ft=mako
autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()
let html_no_rendering=1

let g:closetag_default_xml=1
autocmd FileType html,htmldjango,htmljinja,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako source ~/.vim/scripts/closetag.vim


" CSS
" ---
autocmd FileType css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 omnifunc=csscomplete#CompleteCSS

" rst
" ---
autocmd BufNewFile,BufRead *.rst setlocal ft=rst
autocmd FileType rst setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Inyoka
" ------
autocmd bufNewFile,BufRead *.txt setlocal ft=inyoka
autocmd FileType inyoka setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Javascript
" ----------
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 omnifunc=javascriptcomplete#CompleteJS
let javascript_enable_domhtmlcss=1


" SQL
" ---
autocmd FileType sql setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2


" Sh and Makefile
" ---------------
autocmd FileType make,sh,ksh,zsh,csh,tcsh,bash setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4


" LaTex
" -----
autocmd BufNewFile,BufRead *.tex setlocal ft=tex
autocmd FileType tex setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 textwidth=78


" Vim Syntax
" ----------
autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2


" JSON
" ----
au! BufRead,BufNewFile *.json setfiletype json 


" Folding
" -------
"
"  Some folding abbreviations as well as default saving
"  and loading of fonts.
nmap <C-F> :fold<cr>
nmap <C-S-F> :foldopen<cr>
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview


" File Browser
" ------------
" hide some files and remove stupid help
let g:explHideFiles='^\.,.*\.sw[po]$,.*\.$'
let g:explDetailedHelp=0
map  :Explore!<CR>


" Command-T
" ---------
set wildignore+=*.o,*.obj,.git,*.pyc,*.pyo

" Better Search
" -------------
set hlsearch
set incsearch
set ignorecase


" Minibuffer
" ----------
"  one click is enough and fix some funny bugs
let g:miniBufExplUseSingleClick = 1


" BufClose
" --------
"  map :BufClose to :bq and ^Q

let g:BufClose_AltBuffer = '.'
cnoreabbr <expr> bq 'BufClose'
cnoreabbr <expr> bop 'buffer'
map  :BufClose<cr>

" Supertab
" --------
" Some configuration for supertab

"let g:SuperTabDefaultCompletionType = 'context'
"let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
"let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']

let g:SuperTabDefaultCompletionType = "context"



" Misc Buffer Shortcuts/Configurations
" ------------------------------------
set hidden
nmap <C-Tab> :bnext<cr>
nmap <C-S-Tab> :bprev<cr>
nmap <C-S-Left> :bprev<cr>
nmap <C-S-Right> :bnext<cr>
set switchbuf=useopen		" quickfix reuses open windows


" Mapping for removing that damned  characters
" ----------------------------------------------
nmap <C-S-M> :%s///g<cr>


" Define better search mapping
" ----------------------------
"  `*` searches the current selection forwards
"  `#` searches the current selection backwards
"  `gv` vimgrep' for the current selection
"
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>


" Some omni completition hacking
" ------------------------------
"  * Enter just selects the entry but don't apply it
set completeopt=menuone,longest,preview
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


" Some small NERDTree support
" ---------------------------
function ToggleNERDTree()
  execute 'NERDTreeToggle ' . getcwd()
endfunction
nmap <F5> :call ToggleNERDTree()<cr>


" Buffer indexes :-)
" ------------------

noremap <A-1> :b 1<cr>
noremap <A-2> :b 2<cr>
noremap <A-3> :b 3<cr>
noremap <A-4> :b 4<cr>
noremap <A-5> :b 5<cr>
noremap <A-6> :b 6<cr>
noremap <A-7> :b 7<cr>
noremap <A-8> :b 8<cr>
noremap <A-9> :b 9<cr>
noremap <A-0> :b 10<cr>
noremap <A-q> :b 11<cr>
noremap <A-w> :b 12<cr>
noremap <A-e> :b 13<cr>
noremap <A-r> :b 14<cr>
noremap <A-t> :b 15<cr>


" Bug workarounds
" ---------------
" obviously there are some fancy bugs. Here are some workarounds:

" The r disappears in vertical split. This shortcut is able to restore it
map <C-L> :let &guifont=&guifont<cr>

" Lodgeit
" -------
"
" Copy to Lodgeit on ^p
map <C-p> :Lodgeit<CR>


" Virtualenv
" ----------
"
" Add the virtualenv's site-packages to vim path

py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

" Avoid scrolling problems
set lazyredraw

let g:solarized_termcolors=256
call togglebg#map("<F6>")
let g:solarized_visibility = 'low'
let g:solarized_contrast = 'high'

" Enable Syntax Colors
" --------------------
"  in GUI mode we go with fruity and Consolas 10
"  in CLI mode desert looks better (fruity is GUI only)

if has('gui_running')
    set background=light
    set guifont=Consolas\ 11
    colorscheme solarized
else
    set background=dark
    colorscheme desert
endif
