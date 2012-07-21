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
  if !(neocomplcache#is_text_mode() || neocomplcache#within_comment())
        \ || a:cur_keyword_str !~ '^[[:alpha:]]\+$'
    return []
  endif
  let list = split(neocomplcache#util#system('look ' . a:cur_keyword_str), "\n")
  if neocomplcache#util#get_last_status() != 0
    return []
  endif
  return map(list, "{'word': v:val, 'menu': '[look]'}")
endfunction

function! neocomplcache#sources#look#define()
  return executable('look') ? s:source : {}
endfunction
