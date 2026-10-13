-- LSP（Neovim ネイティブ vim.lsp.config / vim.lsp.enable, 0.11+）
--   nvim-lspconfig が提供する lsp/*.lua プリセット（cmd/filetypes/root）に設定を上乗せする。
--   mason はサーバ・ツールの「インストール」にのみ使う。

-- capabilities: 補完エンジンに応じて構築
local function make_capabilities()
  local engine = vim.g.completion_engine
  if engine == "blink" then
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
      return blink.get_lsp_capabilities()
    end
  elseif engine == "cmp" then
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      return cmp_lsp.default_capabilities()
    end
  end
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- ネイティブ補完でも LSP スニペット展開を受け取れるようにする
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

-- 診断の表示設定
local function setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = true,  -- 行末にエラーメッセージを表示
    signs = true,         -- 行番号の横にエラーアイコン表示
    underline = true,     -- エラー箇所に下線
    update_in_insert = false,  -- 挿入モード中は更新しない
    severity_sort = true,      -- 重要度でソート
    float = {
      border = "rounded",
      source = true,  -- エラーソース（例: pyright）を表示
      header = "",
      prefix = "",
    },
  })

  -- カーソルを置いた時に自動的にエラー詳細を表示（待ち時間は options.lua の updatetime）
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = true,
        prefix = " ",
        scope = "cursor",
      })
    end
  })
end

-- LSP キーマップ
--   on_attach ではなく LspAttach で設定する（nvim-lspconfig の pyright / ts_ls などは
--   独自の on_attach を持っており、vim.lsp.config("*") の on_attach が上書きされて消えるため）
--   Neovim 0.11+ の標準キーをそのまま使い、無いものだけ追加する:
--     K: hover / grn: rename / gra: code action / grr: references / gri: implementation
--     grt: type definition / gO: document symbols / [d ]d: 前後の診断 / <C-w>d: 診断の詳細
--     挿入モード <C-s>: signature help
local function setup_lsp_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
      end

      -- デバッグ: LSPクライアントが起動したことを通知
      vim.notify("LSP attached: " .. (client and client.name or "?"), vim.log.levels.INFO)

      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gD", vim.lsp.buf.declaration, "Go to declaration")
      map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
      map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
      map("<leader>q", vim.diagnostic.setloclist, "Diagnostics to loclist")

      -- ネイティブ補完を有効化（completion_engine = "native" のときのみ）
      if vim.g.completion_engine == "native" and client and client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
    end,
  })
end

-- サーバごとの設定（プリセットに上乗せされる）
local servers = {
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          -- Neovim / プラグインの API 定義は lazydev.nvim が必要な分だけ読み込む
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
}

-- mason で入れるフォーマッター・リンター（LSP サーバは mason-lspconfig の ensure_installed）
local tools = {
  -- フォーマッター
  "prettier",     -- TypeScript/JavaScript/Markdown
  "gofumpt",      -- Go
  "goimports",    -- Go imports
  "stylua",       -- Lua
  -- リンター
  "ruff",         -- Python
  "eslint_d",     -- TypeScript/JavaScript
  "golangci-lint", -- Go
}

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    -- mason v2 は :MasonUpdate を setup() 時に定義するため、build 内で先に setup する
    -- （新規インストール直後は config より先に build が走る）
    build = function()
      require("mason").setup()
      vim.cmd("MasonUpdate")
    end,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      -- 未インストールのツールを自動インストール（レジストリの準備ができてから実行）
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, tool in ipairs(tools) do
          local ok, package = pcall(registry.get_package, tool)
          if ok and not package:is_installed() then
            vim.notify("Installing " .. tool, vim.log.levels.INFO)
            package:install()
          end
        end
      end)
    end,
  },

  -- lazydev.nvim: Neovim 設定を書くときの lua_ls 用に、vim.* や require したプラグインの型定義を供給する
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },  -- vim.uv の型
        { path = "snacks.nvim", words = { "Snacks" } },           -- グローバルの Snacks
      },
    },
  },

  { "williamboman/mason-lspconfig.nvim", lazy = false, dependencies = { "williamboman/mason.nvim" } },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      setup_diagnostics()
      setup_lsp_attach()

      -- mason: サーバのインストールのみ担当
      -- automatic_enable = false: v2 の自動有効化を切り、下の vim.lsp.enable で明示制御する
      -- （自動有効化だと ruff まで LSP として起動してしまうため）
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false,
      })

      -- 全サーバ共通のデフォルト（キーマップは LspAttach で設定）
      vim.lsp.config("*", { capabilities = make_capabilities() })

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
      end

      -- 有効化（ruff は nvim-lint で使うため LSP としては有効化しない）
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
