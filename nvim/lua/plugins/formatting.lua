-- フォーマッター・リンター
return {
  -- フォーマッター（保存時の自動フォーマットは無効。<leader>fm で手動実行）
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        typescript = { "prettier" },
        javascript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        go = { "gofumpt", "goimports" },
        lua = { "stylua" },
        markdown = { "prettier" },
      },
    },
  },

  -- リンター
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
        typescript = { "eslint_d" },
        javascript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        go = { "golangci_lint" },  -- nvim-lint内では golangci_lint（アンダースコア）
      }

      -- ファイル保存時とバッファ読み込み時にリントを実行
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          -- エラーを抑制してリントを実行
          pcall(require("lint").try_lint)
        end,
      })
    end,
  },
}
