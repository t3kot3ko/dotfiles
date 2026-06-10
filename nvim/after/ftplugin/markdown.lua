-- FIXME: Neovim コアのバグ: markdown injection クエリが nil ノードでクラッシュする
-- (treesitter.lua:196 の node:range() を nil ノードで呼ぶ)
-- 組み込み ftplugin/markdown.lua が vim.treesitter.start() を呼ぶため、
-- ここで明示的に停止して二重の安全策とする。
vim.treesitter.stop()

-- vim-matchup の treesitter エンジンも markdown を独自に parse し
-- 同じ injection バグを踏む（CursorMoved 時にクラッシュ）。
-- markdown バッファでは matchup を無効化する。
vim.b.matchup_matchparen_enabled = 0
