-- UI
return {
  -- snacks.nvim: 通知・入力UI・ファジー検索・インデントガイド・ターミナル
  --   起動時の通知（Mason のインストール通知など）も拾えるよう最優先で読み込む
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      notifier = { enabled = true, timeout = 3000 },  -- vim.notify を置き換え（旧 nvim-notify）
      input = { enabled = true },                     -- vim.ui.input を置き換え（旧 dressing.nvim）
      picker = { enabled = true, ui_select = true },  -- ファジー検索（旧 telescope）+ vim.ui.select の置き換え
      indent = { enabled = true },                    -- インデントガイド + スコープ表示（旧 indent-blankline.nvim）
      -- ターミナル（旧 toggleterm）。<Esc> 1 回でノーマルモードに戻る従来の操作感にするため、
      -- snacks 既定の「<Esc> 2 回で戻る」キーを無効化（config/keymaps.lua の t モード <Esc> が効く）
      terminal = { win = { height = 20, keys = { term_normal = false } } },
    },
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "nightfox"
      }
    },
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- which-key.nvim: 押しかけのキーに続く候補をポップアップ表示
  --   :checkhealth which-key で重複・衝突しているキーマップも確認できる
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      -- グループ名（<leader> の後に表示される見出し）
      spec = {
        { "<leader>f", group = "Find / Format" },
        { "<leader>h", group = "Git hunk" },
        { "<leader>x", group = "Diagnostics / Lists" },
        { "gr", group = "LSP" },
        { "t", group = "Tab" },
      },
    },
  },
}
