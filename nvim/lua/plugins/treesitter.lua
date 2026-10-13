-- TreeSitter: 構文解析・ハイライト
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- 下の configs.setup はレガシーの master ブランチの API。リポジトリの既定ブランチは
    -- 書き直し版の main になったため、明示しないと新規クローンや更新で main に切り替わって壊れる
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    -- textobjects は configs.setup の textobjects 設定より先に読み込まれている必要がある
    dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" } },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "typescript", "javascript", "go", "lua", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })

      -- ------------------------------------------------------------------------
      -- 根本対策: nvim-treesitter (master=レガシーブランチ) と Neovim 0.13-dev の
      -- クエリ仕様非互換による markdown injection クラッシュを修正する。
      -- 新しい Neovim ではディレクティブに渡る match[id] がノードの「リスト」になり、
      -- レガシー実装は単一ノード前提のため nil に対し node:range() を呼んで落ちる。
      -- （ハイライター / vim-matchup / LSP ドキュメントフロートの全経路で発生）
      -- 問題の set-lang-from-info-string! を list 対応版で上書きして回避する。
      -- nvim-treesitter を main ブランチへ移行できれば不要になる暫定対応。
      local md_lang_alias = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
      local function parser_from_info_string(alias)
        return vim.filetype.match({ filename = "a." .. alias }) or md_lang_alias[alias] or alias
      end
      vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local node = match[pred[2]]
        -- Neovim 0.11+ では match[id] がノードのリストになる場合がある
        if type(node) == "table" then
          node = node[#node]
        end
        if not node then
          return
        end
        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata["injection.language"] = parser_from_info_string(alias)
      end, { force = true, all = false })
    end,
  },

  { "andymass/vim-matchup", event = { "BufReadPost", "BufNewFile" }, dependencies = "nvim-treesitter/nvim-treesitter" },
}
