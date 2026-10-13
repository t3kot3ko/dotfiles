-- キーマッピング
local map = vim.keymap.set

-- ============================================================================
-- 基本的なナビゲーション
-- ============================================================================
map("n", "j", "gj")
map("n", "k", "gk")
map("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
map("x", "v", "$h")
map("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR>")
map("n", "<S-l>", "<Nop>")
map("n", "<S-h>", "<Nop>")

-- ============================================================================
-- バッファ操作
-- ============================================================================
map("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- タブ操作（従来のタブも使う場合）
map("n", "tc", "<Cmd>tabnew<CR><Cmd>tabmove<CR>", { desc = "New tab" })
map("n", "tx", "<Cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "tn", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "tl", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "tp", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "th", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.api.nvim_create_user_command("TN", "tabnew", {})

-- ============================================================================
-- ファイル操作
-- ============================================================================

-- oil.nvim（現在のファイルのディレクトリをバッファとして開く。oil 内で - を押すとさらに親へ）
map("n", "-", "<Cmd>Oil<CR>", { desc = "Open parent directory (oil)" })

-- Neo-tree（ツリー表示のファイルエクスプローラー）
map("n", "<leader>e", "<Cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- 注: fキーはVim標準の行内文字検索として使用（f{char}で右方向検索）

-- Telescope
map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", "<Cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<Cmd>Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })

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
map("n", "<leader>p", "<Cmd>Telescope yank_history<CR>", { desc = "Yank history" })
map("n", "<c-n>", "<Plug>(YankyCycleForward)")
map("n", "<c-p>", "<Plug>(YankyCycleBackward)")

-- ============================================================================
-- シンボルアウトライン（aerial.nvim）
-- ============================================================================
map("n", "<leader>a", "<Cmd>AerialToggle<CR>", { desc = "Symbol outline" })

-- ============================================================================
-- 開発ツール
-- ============================================================================

-- 現在のファイルを実行（vim-quickrunの代替）
--   LSP の rename は標準の grn を使うため、<leader>r 始まりのキーは置かない（接頭辞衝突の回避）
local runners = {
  python = "python",
  javascript = "node",
  typescript = "ts-node",
  go = "go run",
  lua = "lua",
  sh = "bash",
  bash = "bash",
}
map("n", "<leader>r", function()
  local runner = runners[vim.bo.filetype]
  if not runner then
    vim.notify("No run command for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  -- toggletermで実行
  require("toggleterm").exec(runner .. " " .. vim.fn.expand("%"))
end, { desc = "Run current file" })

-- フォーマット（conform.nvim）
map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- Trouble（診断表示）
map("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (all)" })
map("n", "<leader>xd", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Diagnostics (buffer)" })
map("n", "<leader>xl", "<Cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
map("n", "<leader>xq", "<Cmd>Trouble quickfix toggle<CR>", { desc = "Quickfix list" })

-- 通知履歴（snacks.nvim）
map("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Notification history" })

-- todo-comments（TODOコメント管理）
map("n", "<leader>ft", "<Cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
map("n", "<leader>fT", "<Cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", { desc = "Find TODO/FIX" })
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })
