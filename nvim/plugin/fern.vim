nnoremap ff :Fern . -reveal=% -drawer -toggle -width=40<CR>
function! s:init_fern() abort
	map <buffer> h <Plug>(fern-action-leave)
	map <buffer> v <Plug>(fern-action-open:vsplit)
	map <buffer> s <Plug>(fern-action-open:split)
	map <buffer> tt <Plug>(fern-action-open:tabedit)
	map <buffer> <S-s> <Plug>(fern-action-open:select)
endfunction
augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END


