-- lazy.nvim を使ったプラグイン管理
-- lazy.nvim のインストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- テーマ（起動時に必要）
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
  -- Neovide 専用テーマ（lazy = true: neovide.lua の require() でオンデマンドロード）
  { "catppuccin/nvim", name = "catppuccin", lazy = true },

  -- UI（起動時に必要）
  { "nvim-lualine/lualine.nvim", event = "VeryLazy" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- snacks.nvim: 通知・入力UI・vim.ui.select・インデントガイドを担当
  -- （nvim-notify / dressing.nvim / indent-blankline.nvim の代替。起動直後に setup が必要）
  { "folke/snacks.nvim", lazy = false, priority = 1000 },

  -- キーマップのガイド（押しかけのキーに続く候補を表示）
  { "folke/which-key.nvim" },

  -- 編集支援（遅延読み込み）
  { "windwp/nvim-autopairs", event = "InsertEnter" },
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy" },
  { "folke/flash.nvim", event = "VeryLazy" },
  { "gbprod/yanky.nvim", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  { "folke/todo-comments.nvim", event = { "BufReadPost", "BufNewFile" }, dependencies = "nvim-lua/plenary.nvim" },

  -- LSP・補完（ファイルタイプで遅延読み込み）
  -- mason v2 は :MasonUpdate を setup() 時に定義するため、build 内で先に setup する
  -- （新規インストール直後は plugin-config.lua の setup より先に build が走る）
  { "williamboman/mason.nvim", build = function() require("mason").setup() vim.cmd("MasonUpdate") end, lazy = false },
  { "williamboman/mason-lspconfig.nvim", lazy = false, dependencies = { "williamboman/mason.nvim" } },
  { "neovim/nvim-lspconfig", lazy = false, dependencies = { "williamboman/mason-lspconfig.nvim" } },
  -- 補完エンジンは settings.lua の vim.g.completion_engine で切り替え
  -- blink.cmp は LSP capabilities を起動時に取得するため遅延読み込みしない
  { "saghen/blink.cmp", version = "1.*", lazy = false,
    enabled = vim.g.completion_engine == "blink",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  { "hrsh7th/nvim-cmp", event = "InsertEnter",
    enabled = vim.g.completion_engine == "cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    }
  },

  -- フォーマッター・リンター
  { "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" } },
  { "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },

  -- TreeSitter（ファイル読み込み時）
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = { "BufReadPost", "BufNewFile" } },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost", "BufNewFile" }, dependencies = "nvim-treesitter/nvim-treesitter" },
  { "andymass/vim-matchup", event = { "BufReadPost", "BufNewFile" }, dependencies = "nvim-treesitter/nvim-treesitter" },

  -- ファイル管理
  -- oil.nvim: ディレクトリをバッファとして編集（netrw の代替。ディレクトリを開いた時に効くよう遅延読み込みしない）
  { "stevearc/oil.nvim", lazy = false, dependencies = "nvim-tree/nvim-web-devicons" },
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  { "nvim-telescope/telescope.nvim", cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
    }
  },
  { "stevearc/aerial.nvim", cmd = { "AerialToggle", "AerialOpen" }, dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" } },

  -- ファイル操作（:Rename, :Move, :Delete 等）
  { "tpope/vim-eunuch", cmd = { "Rename", "Move", "Delete", "Mkdir", "Chmod", "SudoWrite" } },

  -- Git（遅延読み込み）
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "GBrowse" } },

  -- 開発ツール（コマンドで遅延読み込み）
  { "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle" }, dependencies = "nvim-tree/nvim-web-devicons" },
  { "akinsho/toggleterm.nvim", version = "*", cmd = { "ToggleTerm", "TermExec" } },
}, {
  -- lazy.nvim の設定
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",  -- vim-matchup が代替するため無効のまま
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
