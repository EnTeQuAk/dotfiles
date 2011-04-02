if exists("b:current_syntax")
finish
endif


syn sync clear
syn sync fromstart


" Kommentarzeilen beginnen mit #.
syn match uucomment "^#.*"

" Allgemein Tags wie [http://www.google.de] oder [:Wikiseite:].
syn region uuanchor matchgroup=anchor start="\[\[\?" skip=/[a-zA-Z_][a-zA-Z0-9_]*/ end="\]\]\?"
syn match uuanchor contained skipwhite /[a-zA-Z_][a-zA-Z0-9_]*/

" Texteigenschaften wie kursiv, fett und Monotype.
syn region uuitalic matchgroup=uuends start="\([^']\|^\)\@<=''" end="''\([^']\|$\)\@="
syn region uubold matchgroup=uuends start="\([^']\|^\)\@<='''" end="'''\([^']\|$\)\@="
syn region uumono matchgroup=uuends start="`\?`" end="`\?`"
syn region uuunder matchgroup=uuends start="__" end="__"
syn region uustrike matchgroup=uuends start="--(" end=")--"

" Überschriften.
syn match uutitle "=\{1,5\}[^=]\+=\{1,5\}"

" Markierungen
syn region uumark matchgroup=uuends start="\[mark\]" end="\[/mark\]"

" Manueller Umbruch
syn match uubreak "\\\\"

" Code-Blöcke.
syn match uucodebang "\({{{\)\@<=#!\(code\|vorlage\) .*"
syn match uucoderegionA "{{{"
syn match uucoderegionB "}}}"

let b:is_bash = 1
syn include @codesh syntax/sh.vim
syn region uucodesh start="\({{{#!code bash\n\)\@<=" end="\(}}}\)\@=" contains=@codesh
unlet b:current_syntax

syn include @codepy syntax/python.vim
syn region uucodepy start="\({{{#!code python\n\)\@<=" end="\(}}}\)\@=" contains=@codepy
unlet b:current_syntax

syn include @codejava syntax/java.vim
syn region uucodejava start="\({{{#!code java\n\)\@<=" end="\(}}}\)\@=" contains=@codejava
unlet b:current_syntax

syn region uucodeunknown start="\({{{\n\)\@<=" end="\(}}}\)\@=" contains=uumark

" Zitate
syn match uuquote1 "\v^(\> ?).*"
syn match uuquote2 "\v^(\> ?){2}.*"
syn match uuquote3 "\v^(\> ?){3}.*"
syn match uuquote4 "\v^(\> ?){4}.*"
syn match uuquote5 "\v^(\> ?){5}.*"
syn match uuquote6 "\v^(\> ?){6}.*"

" Listen
syn match uulistnum " 1\. "
syn match uulistitems1 " \* "
syn match uulistitems2 " \* "
syn match uulistitems3 " \* "
syn match uulistitems4 " \* "


" Wie sieht was aus?
hi link uucomment Comment
hi link uuanchor Identifier
hi def uuitalic cterm=italic
hi def uubold cterm=bold
hi def uuunder cterm=underline
hi link uumono Constant
hi link uustrike Comment
hi link uucodeunknown uumono
hi link uutitle Title
hi link uucodebang Statement
hi link uumark Visual
hi link uucoderegionA Constant
hi link uucoderegionB Constant
hi link uuends Normal
hi link uuquote1 MoreMsg
hi link uuquote2 Identifier
hi link uuquote3 uuquote1
hi link uuquote4 uuquote2
hi link uuquote5 uuquote1
hi link uuquote6 uuquote2
hi link uulistnum Special
hi link uulistitems1 Special
hi link uulistitems2 SpecialKey
hi link uulistitems3 uulistitems1
hi link uulistitems4 uulistitems2
hi link uubreak NonText


let b:current_syntax = "inyoka"
