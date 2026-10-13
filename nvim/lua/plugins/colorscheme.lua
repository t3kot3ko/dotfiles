-- カラースキーム（起動時に必要）
return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
          inverse = {
            match_paren = false,
            search = true,
            visual = true,
          },
          styles = {
            comments = "italic",
            keywords = "bold",
            functions = "italic,bold"
          },
        },
        palettes = {
          all = {
            bg0 = "#000000",  -- 暗い背景（ステータスライン・フロートウィンドウ）
          },
        },
        groups = {
          all = {
            ["@punctuation.delimiter"] = { fg = "palette.red" },
            LspCodeLens = { bg = "#000000", style = "italic" },
            TabLineSel = { bg = "palette.yellow", fg = "palette.black" },
            -- フロートウィンドウ（ピッカー・ホバー・診断・which-key 等）の背景
            --   Ghostty（background-opacity = 0.85）では、透過した通常の背景が実際には #434254 前後に見え、
            --   色付きのセルはその上に 85% の不透明度で重なる（表示色 ≒ 0.85 * 指定色 + 0.15 * #434254）。
            --   そのため #232136 などの暗い色は真っ黒に近く見える。見た目の背景より一段だけ暗く
            --   （表示色 ≒ #3c3b4d）なるよう逆算した色を使い、境界線以外でもフロートの範囲が分かるようにする
            NormalFloat = { fg = "palette.fg1", bg = "#3b3a4c" },
          }
        },
      })

      vim.cmd.colorscheme("duskfox")

      -- カーソルラインを明るくする設定（カラースキーム適用後）
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3c3c" })
    end,
  },
}
