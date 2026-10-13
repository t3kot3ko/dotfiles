-- 補完エンジン（config/options.lua の vim.g.completion_engine で切り替え）
--   "blink" / "cmp" / "native" を実際に試して比較し、気に入った方に決めたら
-- 不要なプラグインをここから削除する。"native" は lua/plugins/lsp.lua の LspAttach で有効化。
return {
  -- blink.cmp: LSP capabilities を起動時に取得するため遅延読み込みしない
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    enabled = vim.g.completion_engine == "blink",
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

  -- nvim-cmp（従来の構成）
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    enabled = vim.g.completion_engine == "cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- friendly-snippetsを読み込む
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- Tab: nvim-cmpの補完を選択
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "lazydev", group_index = 0 },  -- Lua の require("...") でモジュール名を補完
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          })
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}
