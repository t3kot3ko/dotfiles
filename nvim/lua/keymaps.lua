-- キーマッピング
local map = vim.keymap.set

-- ============================================================================
-- 基本的なナビゲーション
-- ============================================================================
map("n", "j", "gj")
map("n", "k", "gk")
map("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
map("v", "v", "$h")
map("n", "<Esc><Esc>", ":nohlsearch<CR>")
-- map("n", "x", "_x")  -- 削除: 行末でxを使うとカーソルが行頭に戻る問題を修正
-- map("n", "s", "_s")  -- 削除: sはflash.nvimで使用
map("n", "<S-l>", "<Nop>")
map("n", "<S-h>", "<Nop>")

-- ============================================================================
-- バッファ操作
-- ============================================================================
map("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- タブ操作（従来のタブも使う場合）
map("n", "tc", ":tabnew<CR>:tabmove<CR>", { silent = true })
map("n", "tx", ":tabclose<CR>", { silent = true })
map("n", "tn", ":tabnext<CR>", { silent = true })
map("n", "tl", ":tabnext<CR>", { silent = true })
map("n", "tp", ":tabprevious<CR>", { silent = true })
map("n", "th", ":tabprevious<CR>", { silent = true })
vim.api.nvim_create_user_command("TN", "tabnew", {})

-- ============================================================================
-- ファイル操作
-- ============================================================================

-- Neo-tree（ファイルエクスプローラー）
map("n", "-", ":Neotree toggle<CR>", { silent = true, desc = "Toggle file explorer" })

-- 注: fキーはVim標準の行内文字検索として使用（f{char}で右方向検索）

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true, desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { silent = true })
map("n", "<leader>fb", ":Telescope buffers<CR>", { silent = true })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { silent = true })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { silent = true })
map("n", "<leader>fc", ":Telescope commands<CR>", { silent = true })

-- ============================================================================
-- 移動（flash.nvim）
-- ============================================================================
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

-- ============================================================================
-- ヤンク履歴（yanky.nvim）
-- ============================================================================
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map("n", "<leader>p", ":Telescope yank_history<CR>", { silent = true })
map("n", "<c-n>", "<Plug>(YankyCycleForward)")
map("n", "<c-p>", "<Plug>(YankyCycleBackward)")

-- ============================================================================
-- シンボルアウトライン（aerial.nvim）
-- ============================================================================
map("n", "<leader>a", ":AerialToggle<CR>", { silent = true })

-- ============================================================================
-- 開発ツール
-- ============================================================================

-- 現在のファイルを実行（vim-quickrunの代替）
map("n", "<Leader>r", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%")
  local cmd = ""

  if ft == "python" then
    cmd = "python " .. file
  elseif ft == "javascript" then
    cmd = "node " .. file
  elseif ft == "typescript" then
    cmd = "ts-node " .. file
  elseif ft == "go" then
    cmd = "go run " .. file
  elseif ft == "lua" then
    cmd = "lua " .. file
  elseif ft == "sh" or ft == "bash" then
    cmd = "bash " .. file
  else
    vim.notify("No run command for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  -- toggletermで実行
  require("toggleterm").exec(cmd)
end, { silent = true, desc = "Run current file" })

-- フォーマット（conform.nvim）
map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { silent = true, desc = "Format buffer" })

-- Trouble（診断表示）
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { silent = true })
map("n", "<leader>xd", ":Trouble diagnostics toggle filter.buf=0<CR>", { silent = true })
map("n", "<leader>xl", ":Trouble loclist toggle<CR>", { silent = true })
map("n", "<leader>xq", ":Trouble quickfix toggle<CR>", { silent = true })

-- todo-comments（TODOコメント管理）
map("n", "<leader>ft", ":TodoTelescope<CR>", { silent = true, desc = "Find TODOs" })
map("n", "<leader>fT", ":TodoTelescope keywords=TODO,FIX,FIXME<CR>", { silent = true, desc = "Find TODO/FIX" })
map("n", "]t", function() require("todo-comments").jump_next() end, { silent = true, desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { silent = true, desc = "Previous TODO" })
