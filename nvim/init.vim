" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0

if !&compatible
	set nocompatible
endif

" reset augroup
augroup MyAutoCmd
	autocmd!
augroup END

augroup BufferAu
    autocmd!
    " カレントディレクトリを自動的に移動
    autocmd BufNewFile,BufRead,BufEnter * if isdirectory(expand("%:p:h")) && bufname("%") !~ "NERD_tree" | cd %:p:h | endif
augroup END

vnoremap v $h
nmap <Esc><Esc> :nohlsearch<CR>

" Use deoplete
" "let g:deoplete#enable_at_startup = 1
" "let g:deoplete#file#enable_buffer_path = 1
" "let g:deoplete#enable_smart_case = 1
" "inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" "let g:deoplete#auto_completion_start_length = 1
" "let g:deoplete#sources = {}
" "let g:deoplete#sources._ = []
" "
" "let g:deoplete#omni#input_patterns = {}
" "let g:deoplete#omni#input_patterns.ruby = "."
" "let g:deoplete#omni#input_patterns.go = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
" "let g:deoplete#omni#input_patterns.java = '[^. *\t]\.\w*'
" "let g:deoplete#omni#input_patterns.php = '\w+|[^. \t]->\w*|\w+::\w*'
" "" let g:deoplete#omni#input_patterns.javascript = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
" "let g:deoplete#omni#input_patterns.javascript = '\.'
" "let g:deoplete#omni#input_patterns.typescript = '\.'
" "
" "let g:deoplete#omni#functions = {}
" "let g:deoplete#omni#functions.javascript = ["LanguageClient#complete"]
" "
" "" Automatically start language servers.
" "let g:LanguageClient_autoStart = 1
" "
" "" Minimal LSP configuration for JavaScript
" "let g:LanguageClient_serverCommands = {}
" "let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
" "" Use LanguageServer for omnifunc completion
" "autocmd FileType javascript setlocal omnifunc=LanguageClient#complete
" "
" "nnoremap gh :call LanguageClient#textDocument_hover() <CR>
" "
" "
" "let g:monster#completion#rcodetools#backend = "async_rct_complete"
" "" let g:monster#completion#solargraph#backend = "async_solargraph_suggest"
" "" let g:monster#completion#backend = 'solargraph'
" ""}}}

let mapleader = "\<Space>"

" Python
let python3_host_prog = $PYENV_ROOT . "/versions/neovim3/bin/python"
let python_host_prog  = $PYENV_ROOT . "/versions/neovim2/bin/python"

" Tab
nnoremap <Space>t t
nnoremap <Space>T T
nnoremap t <Nop>
nnoremap <silent> tc :<C-u>tabnew<CR>:tabmove<CR>
nnoremap <silent> tx :<C-u>tabclose<CR>
nnoremap <silent> tn :<C-u>tabnext<CR>
nnoremap <silent> tl :<C-u>tabnext<CR>
nnoremap <silent> tp :<C-u>tabprevious<CR>
nnoremap <silent> th :<C-u>tabprevious<CR>
nnoremap <silent> t1 :<C-u>tabnext 1<CR>
nnoremap <silent> t2 :<C-u>tabnext 2<CR>
nnoremap <silent> t3 :<C-u>tabnext 3<CR>
nnoremap <silent> t4 :<C-u>tabnext 4<CR>
nnoremap <silent> t5 :<C-u>tabnext 5<CR>
nnoremap <silent> t6 :<C-u>tabnext 6<CR>
nnoremap <silent> t7 :<C-u>tabnext 7<CR>
nnoremap <silent> t8 :<C-u>tabnext 8<CR>
nnoremap <silent> t9 :<C-u>tabnext 9<CR>
nnoremap <silent> t0 :<C-u>tabnext 10<CR>
command TN tabnew
nnoremap <C-g><C-g> :Unite tab<CR>


" let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set cursorline
set backspace=2
set history=999         " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set tabstop=2
set shiftwidth=2
set shortmess+=I
set visualbell
set listchars=eol:$,tab:>-
set listchars=tab:\ \ 
set grepprg=search\ $*
set number
set showmatch
set showmode
set noexpandtab
set wildmenu
set autoindent 
set smartindent 
set smarttab
set title
set ignorecase
set smartcase
set wrapscan
set list
set hlsearch
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set clipboard=unnamed,unnamedplus
set showtabline=2			" Always shows tabs (even when only one file is opening)

" Backup / swap
set swapfile
set nobackup
set undodir=~/.vim/.undo

" avoid Japanese caracters to be marked as spell-error
set spelllang+=cjk
set wildmode=list:longest

nnoremap j gj
nnoremap k gk

tnoremap <silent> <ESC> <C-\><C-n>

" nnoremap <unique> <silent> <C-S> :FufBuffer!<CR>
" nnoremap <unique> <silent> ef :FufFile!<CR>
nnoremap <silent> eff :FufFile!<CR>
nnoremap <silent> efm :FufMruFile!<CR>
autocmd FileType fuf nmap <C-c> <ESC>
let g:fuf_patternSeparator = ' '
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_mrufile_exclude = '\v\~$|\.bak$|\.swp|\.howm$'
let g:fuf_mrufile_maxItem = 2000
let g:fuf_enumeratingLimit = 20

nnoremap <silent> ff :Unite file_mru<CR>

" pythonのrename用のマッピングがquickrunとかぶるため回避させる
let g:jedi#rename_command = ""

" Python でコメントを入力するとき，行頭に戻らないように
autocmd FileType python inoremap # X#

" ctags (to avoid conflict between tmux escape-sequence)
nnoremap <C-[> <C-t>

" gtags
"" list functions defined in a file
" map <C-h> :Gtags -f %<CR>
"" jump location where the cursor is referred to
map <C-k> :Gtags -r <C-r><C-w><CR>
"" jump to the definition
map <C-j> :GtagsCursor<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

" Rename
command! -nargs=+ -bang -complete=file Rename let pbnr=fnamemodify(bufname('%'), ':p')|exec 'f '.escape(<q-args>, ' ')|w<bang>|call delete(pbnr)

" dirvish
augroup dirvish_config
	autocmd!

	" Map `t` to open in new tab.
	autocmd FileType dirvish
				\  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
				\ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>

	" Map `gr` to reload.
	autocmd FileType dirvish nnoremap <silent><buffer>
				\ gr :<C-U>Dirvish %<CR>

	" Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
	autocmd FileType dirvish nnoremap <silent><buffer>
				\ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>
augroup END

map <leader>1 <Plug>ToggleAutoCloseMappings

" coc-nvim
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader><S-a>  <Plug>(coc-codeaction-selected)
nmap <leader><S-a>  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>"


" dein settings {{{
" ===== Install dein itself =====
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
	call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

" ===== Load plugins and create cache =====
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
	call dein#load_toml(s:toml_file)
	call dein#end()
	call dein#save_state()
endif

" ===== Install missing plugins =====
if has('vim_starting') && dein#check_install()
	call dein#install()
endif

call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

let g:go_higlight_functions = 1
let g:go_higlight_methods = 1
let g:go_higlight_structs = 1



" Indent settings {{{
filetype on
filetype plugin on
filetype indent on
syntax on
" }}}


