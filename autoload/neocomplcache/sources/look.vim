let s:source = {
      \ 'name': 'look',
      \ 'kind': 'plugin',
      \ }

function! s:source.initialize()
  call neocomplcache#set_completion_length('look', 3)
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_list(cur_keyword_str)
  if !neocomplcache#is_text_mode()
        \ || a:cur_keyword_str !~ '^\w\+$' " always ignore multibyte characters
    return []
  endif

  return map(split(neocomplcache#system('look ' . a:cur_keyword_str), "\n"),
        \ "{'word': v:val, 'menu': 'look'}")
endfunction

function! neocomplcache#sources#look#define()
  return executable('look') ? s:source : {}
endfunction
