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

-- ファジー検索（snacks.picker）
--   ピッカー内: <C-j>/<C-k> 移動, <CR> 開く, <C-v>/<C-s> 縦/横分割, <C-t> タブ,
--   <Tab> 複数選択, <C-q> quickfix へ送る, <A-h> 隠しファイル切替,
--   <Esc> ノーマルモード（j/k で移動、? でキー一覧、もう一度 <Esc> で閉じる）
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
map({ "n", "x" }, "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "Grep word / selection" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>fc", function() Snacks.picker.commands() end, { desc = "Commands" })
map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "LSP symbols" })
map("n", "<leader>fu", function() Snacks.picker.undo() end, { desc = "Undo history" })
map("n", "<leader>f.", function() Snacks.picker.resume() end, { desc = "Resume last picker" })
map("n", "<leader><leader>", function() Snacks.picker.smart() end, { desc = "Smart find (buffers/recent/files)" })

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
map("n", "<leader>p", function() Snacks.picker.yanky() end, { desc = "Yank history" })
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
  -- 下部の分割ターミナルで実行（終了後も結果を読めるよう自動で閉じない。q で閉じる）
  vim.cmd("silent! update")
  Snacks.terminal.open(runner .. " " .. vim.fn.shellescape(vim.fn.expand("%")), {
    auto_close = false,
    win = { position = "bottom" },
  })
end, { desc = "Run current file" })

-- ターミナルの開閉（<C-\>。ターミナル内でも同じキーで閉じる）
map({ "n", "t" }, [[<C-\>]], function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })

-- フォーマット（conform.nvim）
map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- 診断・リスト（snacks.picker。旧 Trouble と同じキー）
map("n", "<leader>xx", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics (all)" })
map("n", "<leader>xd", function() Snacks.picker.diagnostics_buffer() end, { desc = "Diagnostics (buffer)" })
map("n", "<leader>xl", function() Snacks.picker.loclist() end, { desc = "Location list" })
map("n", "<leader>xq", function() Snacks.picker.qflist() end, { desc = "Quickfix list" })

-- 通知履歴（snacks.nvim）
map("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Notification history" })

-- todo-comments（TODOコメント管理）
map("n", "<leader>ft", function() Snacks.picker.todo_comments() end, { desc = "Find TODOs" })
map("n", "<leader>fT", function()
  Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Find TODO/FIX" })
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })
