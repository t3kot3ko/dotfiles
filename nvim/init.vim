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
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shortmess+=I
set visualbell
set listchars=eol:$,tab:>-
set listchars=tab:\ \ 
set grepprg=search\ $*
set number
set showmatch
set showmode
set expandtab
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
set scrolloff=1

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

" Python
if has("unix") || has("mac")
	let python3_host_prog = $PYENV_ROOT . "/versions/neovim3/bin/python"
	let python_host_prog  = $PYENV_ROOT . "/versions/neovim2/bin/python"
elseif has("win64") || has("win64")
	let python3_host_prog = "c:\\Python37\\python.exe"
	let python_host_prog  = "c:\\Python27\\python.exe"
endif

" Rename
command! -nargs=+ -bang -complete=file Rename let pbnr=fnamemodify(bufname('%'), ':p')|exec 'f '.escape(<q-args>, ' ')|w<bang>|call delete(pbnr)
"}}}

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugins
call plug#begin('$HOME/.local/share/nvim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' } 
Plug 'nvim-lualine/lualine.nvim'
Plug 'cohama/lexima.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'vim-scripts/YankRing.vim'
Plug 'thinca/vim-quickrun'
Plug 'vim-scripts/surround.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/spinner.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'APZelos/blamer.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'folke/trouble.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'github/copilot.vim'
Plug 'airblade/vim-rooter'
Plug 'liuchengxu/vista.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'simeji/winresizer'
Plug 'simeji/winresizer'
Plug 'hoschi/yode-nvim'

" Colorschems
Plug 'NLKNguyen/papercolor-theme'
Plug 'EdenEast/nightfox.nvim'

" nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Ruby / Rails
Plug 'tpope/vim-rails'
Plug 'vim-scripts/ruby-matchit'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Markdown
Plug 'plasticboy/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'
Plug 'dhruvasagar/vim-table-mode'

" Python
Plug 'mgedmin/python-imports.vim'

" Golang
Plug 'mattn/vim-goimports'

call plug#end()

" Plugin settings
" "runtime 'plugin/completion.vim'
" "runtime 'plugin/nvim-tresitter.vim'
" "runtime 'plugin/fern.vim'

let g:blamer_enabled = 1
let g:rooter_manual_only = 1
let g:rooter_patterns = ['.git', 'Makefile', '*.sln', 'build/env.sh']

" Colorscheme
set background=dark
colorscheme PaperColor
let g:PaperColor_Theme_Options = 
      \{
      \  'theme': {
      \    'default.dark': {
      \      'transparent_background': 1,
      \    }
      \  }
      \}
let g:dracula_colorterm = 0

lua << EOF
require('yode-nvim').setup({})
EOF

lua << EOF
local nightfox = require('nightfox')

-- This function set the configuration of nightfox. If a value is not passed in the setup function
-- it will be taken from the default configuration above
nightfox.setup({
options = {
    transparent = true, -- do not set background color
    inverse = {
        match_paren = false, -- inverse the highlighting of match_parens
        search = true,
        visual = true,
        },
    styles = {
        comments = "italic", -- change style of comments to be italic
        keywords = "bold", -- change style of keywords to be bold
        functions = "italic,bold" -- styles can be a comma separated list
        },
    },
paletts = {
    bg_alt = "#000000",
    },
groups = {
    all= {
        TSPunctDelimiter = { fg = "palette.red" }, -- Override a highlight group with the color red
        LspCodeLens = { bg = "#000000", style = "italic" },
        TabLineSel = { bg = "palette.yellow", fg = "palette.black" },
        }
    },
})

EOF

colorscheme duskfox


lua << EOF
require('lualine').setup {
  options = {
    -- ... your lualine config
    theme = "nightfox"
  }
}
EOF

let g:airline_theme='papercolor'

" Disable Copilot on startup
autocmd VimEnter * Copilot disable


" Keymappings {{{
nnoremap j gj
nnoremap k gk
tnoremap <silent> <ESC> <C-\><C-n>"

vnoremap v $h
nmap <Esc><Esc> :nohlsearch<CR>

" Don't put char into register
nnoremap x "_x
nnoremap s "_s

" Don't jump to top/bottom with S-h / S-l
nnoremap <S-l> <Nop>
nnoremap <S-h> <Nop>

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


" Python でコメントを入力するとき，行頭に戻らないように
autocmd FileType python inoremap # X#

" ctags/gtags{{{
" ctags (to avoid conflict between tmux escape-sequence)
" nnoremap <C-[> <C-t>

" gtags
"" list functions defined in a file
" map <C-h> :Gtags -f %<CR>
"" jump location where the cursor is referred to
map <C-k> :Gtags -r <C-r><C-w><CR>
"" jump to the definition
map <C-j> :GtagsCursor<CR>
nnoremap <C-n> :cn<CR>
nnoremap <C-p> :cp<CR>"}}}

let g:go_higlight_functions = 1
let g:go_higlight_methods = 1
let g:go_higlight_structs = 1

" Indent settings {{{
filetype on
filetype plugin on
filetype indent on
syntax on
" }}}


