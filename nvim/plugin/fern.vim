nnoremap ff :Fern . -reveal=% -drawer -toggle -width=40<CR>
function! s:init_fern() abort
	nmap <buffer> h <Plug>(fern-action-leave)
endfunction
augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END


