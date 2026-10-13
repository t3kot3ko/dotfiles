-- 補完: blink.cmp（LSP / パス / バッファ / スニペット、入力中のシグネチャ表示）
return {
  -- blink.cmp: LSP capabilities を起動時に取得するため遅延読み込みしない
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "enter",  -- <C-Space>: 表示, <C-e>: 閉じる, <C-b>/<C-f>: ドキュメントのスクロール
        -- <CR>: 未選択でも先頭の候補を確定（nvim-cmp の confirm({ select = true }) 相当）
        ["<CR>"] = { "select_and_accept", "fallback" },
        -- Tab: 補完候補の選択 → スニペットのジャンプ（nvim-cmp 時代と同じ操作感）
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        menu = { border = "rounded" },
        documentation = { auto_show = true, window = { border = "rounded" } },
      },
      -- 入力中のシグネチャ表示（旧 lsp_signature.nvim）
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },  -- snippets は friendly-snippets を自動で読み込む
        providers = {
          -- Lua の require("...") でモジュール名を補完（lazydev.nvim）
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      -- コマンドライン補完は従来どおり Vim 標準（wildmenu）を使う
      cmdline = { enabled = false },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
