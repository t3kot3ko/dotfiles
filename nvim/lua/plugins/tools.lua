-- 開発ツール
return {
  -- 診断・参照のリスト表示（:Trouble コマンドは setup() で定義されるため opts が必要）
  { "folke/trouble.nvim", cmd = "Trouble", dependencies = "nvim-tree/nvim-web-devicons", opts = {} },

  -- ターミナル（<C-\> で開閉。<leader>r のファイル実行もここで動く）
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = { [[<C-\>]] },
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      close_on_exit = true,
    },
  },
}
