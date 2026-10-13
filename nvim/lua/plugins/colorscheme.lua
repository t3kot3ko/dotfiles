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
          }
        },
      })

      vim.cmd.colorscheme("duskfox")

      -- カーソルラインを明るくする設定（カラースキーム適用後）
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3c3c" })
    end,
  },
}
