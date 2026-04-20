-- lazy.nvim を使ったプラグイン管理
-- lazy.nvim のインストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = { "BufReadPost", "BufNewFile" } },
  { "rcarriga/nvim-notify", event = "VeryLazy" },
  { "stevearc/dressing.nvim", event = "VeryLazy" },

  -- 編集支援（遅延読み込み）
  { "windwp/nvim-autopairs", event = "InsertEnter" },
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy" },
  { "folke/flash.nvim", event = "VeryLazy" },
  { "gbprod/yanky.nvim", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  { "folke/todo-comments.nvim", event = { "BufReadPost", "BufNewFile" }, dependencies = "nvim-lua/plenary.nvim" },

  -- LSP・補完（ファイルタイプで遅延読み込み）
  { "williamboman/mason.nvim", build = ":MasonUpdate", lazy = false },
  { "williamboman/mason-lspconfig.nvim", lazy = false, dependencies = { "williamboman/mason.nvim" } },
  { "neovim/nvim-lspconfig", lazy = false, dependencies = { "williamboman/mason-lspconfig.nvim" } },
  { "hrsh7th/nvim-cmp", event = "InsertEnter",
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
  { "ray-x/lsp_signature.nvim", event = "LspAttach" },

  -- フォーマッター・リンター
  { "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" } },
  { "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },

  -- TreeSitter（ファイル読み込み時）
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = { "BufReadPost", "BufNewFile" } },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost", "BufNewFile" }, dependencies = "nvim-treesitter/nvim-treesitter" },

  -- ファイル管理（コマンドで遅延読み込み）
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

  -- Git（遅延読み込み）
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },
  { "tpope/vim-fugitive", cmd = { "Git", "Gstatus", "Gblame" } },

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
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
