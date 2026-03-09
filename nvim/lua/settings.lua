-- 基本的なオプション設定
local opt = vim.opt
local g = vim.g

-- リーダーキーをスペースに設定（デフォルトは\）
g.mapleader = " "
g.maplocalleader = " "

-- 互換性レイヤー: vim.tbl_islist を vim.islist にエイリアス（Neovim 0.12対応）
if vim.fn.has("nvim-0.10") == 1 and not vim.tbl_islist then
  vim.tbl_islist = vim.islist
end

-- パフォーマンス最適化
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.redrawtime = 1500
opt.synmaxcol = 200

opt.cursorline = true
opt.autochdir = true
opt.backspace = { "indent", "eol", "start" }
opt.history = 999
opt.ruler = true
opt.showcmd = true
opt.incsearch = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.shortmess:append("I")
opt.visualbell = true
opt.list = true
opt.listchars = "tab:  ,eol:$"
opt.grepprg = "search $*"
opt.number = true
opt.showmatch = true
opt.showmode = true
opt.expandtab = true
opt.wildmenu = true
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.title = true
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true
opt.hlsearch = true
opt.laststatus = 2
opt.statusline = "%f %l,%c%V %P"
opt.clipboard = "unnamed,unnamedplus"
opt.showtabline = 2
opt.scrolloff = 1
opt.signcolumn = "yes:1"
opt.swapfile = true
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/.undo")
opt.spelllang:append("cjk")
opt.wildmode = { "list", "longest" }

-- Python host
if vim.fn.has("unix") == 1 or vim.fn.has("mac") == 1 then
  local pyenv_root = os.getenv("PYENV_ROOT")
  if pyenv_root then
    g.python3_host_prog = pyenv_root .. "/versions/neovim3/bin/python"
    g.python_host_prog = pyenv_root .. "/versions/neovim2/bin/python"
  end
elseif vim.fn.has("win64") == 1 then
  g.python3_host_prog = "c:/Python37/python.exe"
  g.python_host_prog = "c:/Python27/python.exe"
end

-- rooter
g.rooter_manual_only = 1
g.rooter_patterns = { ".git", "Makefile", "*.sln", "build/env.sh" }

-- Indent, filetype, syntax
vim.cmd([[filetype on]])
vim.cmd([[filetype plugin on]])
vim.cmd([[filetype indent on]])
vim.cmd([[syntax on]])
