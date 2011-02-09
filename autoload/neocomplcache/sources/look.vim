let s:source = {
      \ 'name': 'look',
      \ 'kind': 'plugin',
      \ }

function! s:source.initialize()
  call neocomplcache#set_completion_length('look', 3)
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_pos(cur_text)
  return s:last_matchend(a:cur_text[:getpos('.')[2]], '\W')
endfunction

function! s:source.get_keyword_list(cur_keyword_str)
  if !neocomplcache#is_text_mode()
    return []
  endif
  if a:cur_keyword_str !~ '^\w\+$' " always ignore multibyte characters
    return []
  endif
  let list = split(neocomplcache#system('look ' . a:cur_keyword_str), "\n")
  return map(list, "{'word': v:val, 'menu': 'look'}")
endfunction

function! neocomplcache#sources#look#define()
  return executable('look') ? s:source : {}
endfunction 

function! s:last_matchend(str, pat)
  let l:idx = matchend(a:str, a:pat)
  let l:ret = 0
  while l:idx != -1
    let l:ret = l:idx
    let l:idx = matchend(a:str, a:pat, l:ret)
  endwhile
  return l:ret
endfunction
