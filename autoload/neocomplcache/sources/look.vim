let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name': 'look',
      \ 'kind': 'plugin',
      \ 'mark': '[look]',
      \ 'max_candidates': 15,
      \ 'min_pattern_length' : 4,
      \ 'is_volatile' : 1,
      \ }

function! s:source.get_keyword_list(cur_keyword_str)
  if !(&spell || neocomplcache#is_text_mode()
        \ || neocomplcache#within_comment())
        \ || a:cur_keyword_str !~ '^[[:alpha:]]\+$'
    return []
  endif

  let list = split(neocomplcache#util#system(
        \ 'look ' . a:cur_keyword_str), "\n")
  if neocomplcache#util#get_last_status()
    return []
  endif

  return map(list, "substitute(v:val,
        \ '^' . tolower(a:cur_keyword_str), a:cur_keyword_str, '')")
endfunction

function! neocomplcache#sources#look#define()
  return executable('look') ? s:source : {}
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
