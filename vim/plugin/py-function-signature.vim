if v:version < 700
  finish
endif

" XXX breaks I in visual block mode :(
inoremap <silent> ( (<C-O>:call ShowFunctionSignature()<CR>
"" does not work: when you press <C-V>I, mode() returns "i".
""noremap <expr> <silent> ( "(" . (mode() == "i" ? "<C-O>:call ShowFunctionSignature()<CR>" : "")

function! FindBestTagsForName(name)
  if a:name[0] == '.'
    let method = 1
    let name = a:name[1:]
  else
    let method = 0
    let name = a:name
  endif
  silent! let tags = taglist('^' . name . '$')
  if method
    let tags = filter(tags, 'has_key(v:val, "class")')
  else
    let tags = filter(tags, '!has_key(v:val, "class")')
  endif
  let tests = filter(copy(tags), 'v:val["filename"] =~ "test"')
  let tags = filter(tags, 'v:val["filename"] !~ "test"') + tests
  return tags
endfunction

function! FindConstructorForClass(name)
  let tags = taglist('^__init__$')
  let tags = filter(tags, 'has_key(v:val, "class") && v:val["class"] == a:name')
  return tags
endfunction

function! GetWordLeftOfCursor()
  let line = getline('.')
  " magick adjustment to the left:
  "    word(X...
  "    123456  <= col('.') is 6
  "    0123    <= string indices
  let col = col('.') - 3
  if col('.') == col('$') - 1
    " special case for end of line
    "    word(X
    "    12345   <= col('.') is 5, col('$') is 6
    "    0123    <= string indices
    let col = col + 1
  endif
  if col < 0
    return ""
  endif
  let word = matchstr(line[:col], '[.]\=[a-zA-Z_][a-zA-Z_0-9]*$')
  return word
endfunction

function! ShowFunctionSignature()
  let name = GetWordLeftOfCursor()
  if name == ''
    return
  endif
  let tags = FindBestTagsForName(name)
  if tags == []
    return
  endif

  if tags[0]['kind'] == 'c'
    let tags = FindConstructorForClass(name)
    if tags == []
      return
    endif
  endif

  let nth = 0
  if exists("b:PFS_last_pos") && b:PFS_last_pos == getpos(".")
    let nth = b:PFS_last_nth + 1
    if nth >= len(tags)
      let nth = 0
    endif
  endif
  let b:PFS_last_pos = getpos(".")
  let b:PFS_last_nth = nth
  let tag = tags[nth]
  let signature = tag['cmd']
  let signature = substitute(signature, '^/^', '', '')
  let signature = substitute(signature, '$/$', '', '')
  let signature = substitute(signature, '^\s*def ', '', '')
  let signature = substitute(signature, '(self, ', '(', '')
  let signature = substitute(signature, ', $', ', ...', '')
  let signature = substitute(signature, ':$', '', '')
  if has_key(tag, 'class')
    let signature = tag['class'] . '.' . signature
  endif
  if len(tags) > 1
    let signature = signature . " and " . (len(tags) - 1) . " more "
  endif
  let signature = signature . "  "
  let filename = tag['filename']
  let width = &columns - len(signature)
  if len(filename) > width
    let width = width - 3
    if width > 0
      let filename = '...' . filename[len(filename)-width :]
    else
      let filename = ''
    endif
  else
    let filename = printf("%*s", width, filename)
  endif
  echo signature . filename
endfunction

" Example: queryAdapter(, getAdapter, queryUtility(
" TestRequest(  __init__(  def __init__(
" provideAdapter(
" queryUtility(
" TestRequest(
