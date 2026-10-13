-- 編集支援
return {
  -- 括弧の自動補完
  --   （補完確定時の関数の括弧は blink.cmp が自前で補うため、補完との連携設定は不要）
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
    },
  },

  { "kylechui/nvim-surround", version = "*", event = "VeryLazy" },

  -- 高速移動（キーマップは config/keymaps.lua の s / S）
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- ラベルの表示設定
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
      },
      jump = {
        jumplist = true,
        pos = "start",
        history = false,
        register = false,
        nohlsearch = false,
        autojump = false,
      },
      label = {
        uppercase = false,
        rainbow = {
          enabled = false,
        },
      },
      modes = {
        search = {
          enabled = false,  -- 通常の/検索は無効（sキーを使う）
        },
        char = {
          enabled = true,  -- f/t/F/Tのラベル表示を有効化
          jump_labels = true,
          multi_line = true,
        },
      },
    },
  },

  -- ヤンク履歴（キーマップは config/keymaps.lua）
  --   snacks より後に読み込むと Snacks.picker.yanky() が自動で登録される
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    dependencies = "folke/snacks.nvim",
    opts = {
      highlight = {
        timer = 150,
      },
    },
  },

  -- コメントアウトは Neovim 標準の gc / gcc を使う（0.10+。Treesitter で埋め込み言語も判定）

  -- TODOコメント管理（setup 時に Snacks.picker.todo_comments() が登録される）
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },
}
