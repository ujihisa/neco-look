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

function! s:source.gather_candidates(context)
  if neocomplete#is_auto_complete() &&
        \ !(&spell || neocomplete#is_text_mode()
        \   || neocomplete#within_comment())
        \ || a:context.complete_str !~ '^[[:alpha:]]\+$'
    return []
  endif

  let list = split(neocomplete#util#system(
        \ 'look ' . a:context.complete_str), "\n")
  if neocomplete#util#get_last_status()
    return []
  endif

  return map(list, "substitute(v:val,
        \ '^' . tolower(a:context.complete_str),
        \ a:context.complete_str, '')")
endfunction

function! neocomplete#sources#look#define()
  return executable('look') ? s:source : {}
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
