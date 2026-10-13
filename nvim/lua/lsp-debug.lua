-- LSP診断用の一時ファイル
-- このファイルを保存後、Neovimを再起動して :LspDebug を実行

vim.api.nvim_create_user_command("LspDebug", function()
  print("=== LSP診断情報 ===")

  -- Masonの状態確認
  local mason_registry = require("mason-registry")
  local pyright_installed = mason_registry.is_installed("pyright")
  print("Pyright installed: " .. tostring(pyright_installed))

  -- 現在のバッファのLSPクライアント確認
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  print("Active LSP clients: " .. #clients)
  for _, client in ipairs(clients) do
    print("  - " .. client.name)
  end

  -- 補完エンジンの状態確認
  print("Completion engine: " .. tostring(vim.g.completion_engine))
  local blink_ok = pcall(require, "blink.cmp")
  print("blink.cmp loaded: " .. tostring(blink_ok))
  local cmp_ok = pcall(require, "cmp")
  print("nvim-cmp loaded: " .. tostring(cmp_ok))

  -- Pythonの実行可能ファイル
  local python_path = vim.fn.exepath("python") .. " or " .. vim.fn.exepath("python3")
  print("Python path: " .. python_path)

  print("\n診断完了。上記の情報を確認してください。")
end, {})
