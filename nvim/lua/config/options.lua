-- 基本的なオプション設定
-- （Neovim の既定値と同じもの: backspace, ruler, showcmd, incsearch, wildmenu, autoindent,
--   smarttab, hlsearch, wrapscan, showmode, laststatus=2, swapfile, nobackup,
--   filetype/syntax on は書かない）
local opt = vim.opt
local g = vim.g

-- リーダーキーをスペースに設定（デフォルトは\）
g.mapleader = " "
g.maplocalleader = " "

-- パフォーマンス最適化
opt.updatetime = 500  -- CursorHold（診断フロートの自動表示）までの待ち時間
opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.redrawtime = 1500
opt.synmaxcol = 200

opt.cursorline = true
opt.autochdir = true
opt.history = 999
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.shortmess:append("I")
opt.visualbell = true
opt.list = true
opt.listchars = "tab:  ,eol:$"
opt.grepprg = "rg --vimgrep --smart-case"  -- :grep を ripgrep で実行
opt.grepformat = "%f:%l:%c:%m"
opt.number = true
opt.showmatch = true
opt.title = true
opt.ignorecase = true
opt.smartcase = true
opt.statusline = "%f %l,%c%V %P"  -- lualine が読み込まれるまでの表示
opt.clipboard = "unnamed,unnamedplus"
opt.showtabline = 2
opt.scrolloff = 1
opt.signcolumn = "yes:1"
opt.undofile = true  -- アンドゥ履歴をファイルに保存（保存先は既定の stdpath("state")/undo）
opt.spelllang:append("cjk")
opt.wildmode = { "list", "longest" }

-- Python host
local pyenv_root = os.getenv("PYENV_ROOT")
if pyenv_root then
  g.python3_host_prog = pyenv_root .. "/versions/neovim3/bin/python"
end
