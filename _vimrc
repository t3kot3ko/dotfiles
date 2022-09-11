" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0

if !&compatible
	set nocompatible
endif

let mapleader = "\<Space>"

" Common settings{{{
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

" reset augroup
augroup MyAutoCmd
	autocmd!
augroup END

augroup BufferAu
    autocmd!
    " カレントディレクトリを自動的に移動
    autocmd BufNewFile,BufRead,BufEnter * if isdirectory(expand("%:p:h")) && bufname("%") !~ "NERD_tree" | cd %:p:h | endif
augroup END

" Rename
command! -nargs=+ -bang -complete=file Rename let pbnr=fnamemodify(bufname('%'), ':p')|exec 'f '.escape(<q-args>, ' ')|w<bang>|call delete(pbnr)
"}}}

" Install plug.vim manually
" cf. https://github.com/junegunn/vim-plug

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugins
call plug#begin('c:\vim\.local\share\nvim\plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'dracula/vim', { 'as': 'dracula' } 

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/AutoClose'
Plug 'vim-scripts/YankRing.vim'
Plug 'thinca/vim-quickrun'
Plug 'vim-scripts/surround.vim'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/spinner.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'hrsh7th/vim-vsnip'

" Markdown
Plug 'plasticboy/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'
Plug 'dhruvasagar/vim-table-mode'

call plug#end()

" Colorscheme
set background=dark

" Keymappings {{{
nnoremap j gj
nnoremap k gk
tnoremap <silent> <ESC> <C-\><C-n>"

vnoremap v $h
nmap <Esc><Esc> :nohlsearch<CR>

" Don't put char into register
nnoremap x "_x
nnoremap s "_s

" tab
nnoremap <silent> tc :<C-u>tabnew<CR>:tabmove<CR>
nnoremap <silent> tx :<C-u>tabclose<CR>
nnoremap <silent> tn :<C-u>tabnext<CR>
nnoremap <silent> tl :<C-u>tabnext<CR>
nnoremap <silent> tp :<C-u>tabprevious<CR>
nnoremap <silent> th :<C-u>tabprevious<CR>
command TN tabnew

nnoremap <silent><Leader>r :<C-u>QuickRun <CR>

"}}}

" Plugin settings
"" fern.vim
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

" Indent settings {{{
filetype on
filetype plugin on
filetype indent on
syntax on
" }}}
