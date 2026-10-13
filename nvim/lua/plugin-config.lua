-- プラグイン個別設定

-- ============================================================================
-- snacks.nvim: 通知・入力UI・選択UI・インデントガイド
--   起動時の通知（Mason のインストール通知など）も拾えるよう最初に setup する
-- ============================================================================
pcall(function()
  require("snacks").setup({
    notifier = { enabled = true, timeout = 3000 },  -- vim.notify を置き換え（旧 nvim-notify）
    input = { enabled = true },                     -- vim.ui.input を置き換え（旧 dressing.nvim）
    picker = { enabled = true, ui_select = true },  -- vim.ui.select を置き換え（ファイル検索等は Telescope のまま）
    indent = { enabled = true },                    -- インデントガイド + スコープ表示（旧 indent-blankline.nvim）
  })
end)

-- ============================================================================
-- Mason: LSPサーバー、フォーマッター、リンターの管理
-- ============================================================================
pcall(function()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })

  -- 初回起動時に必要なツールを自動インストール
  local mason_registry = require("mason-registry")
  local tools_to_install = {
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

  for _, tool in ipairs(tools_to_install) do
    local package = mason_registry.get_package(tool)
    if not package:is_installed() then
      vim.notify("Installing " .. tool, vim.log.levels.INFO)
      package:install()
    end
  end
end)

-- ============================================================================
-- LSP設定（Neovim 0.11+ 対応）
-- ============================================================================

-- 診断メッセージの自動表示設定
vim.diagnostic.config({
  virtual_text = true,  -- 行末にエラーメッセージを表示
  signs = true,         -- 行番号の横にエラーアイコン表示
  underline = true,     -- エラー箇所に下線
  update_in_insert = false,  -- 挿入モード中は更新しない
  severity_sort = true,      -- 重要度でソート
  float = {
    border = "rounded",
    source = "always",  -- エラーソース（例: pyright）を表示
    header = "",
    prefix = "",
  },
})

-- カーソルを置いた時に自動的にエラー詳細を表示
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    })
  end
})

-- CursorHoldの待ち時間を短く設定（デフォルト4000ms → 500ms）
vim.opt.updatetime = 500

-- LSP キーマップ
--   on_attach ではなく LspAttach で設定する（nvim-lspconfig の pyright / ts_ls などは
--   独自の on_attach を持っており、vim.lsp.config("*") の on_attach が上書きされて消えるため）
--   Neovim 0.11+ の標準キーをそのまま使い、無いものだけ追加する:
--     K: hover / grn: rename / gra: code action / grr: references / gri: implementation
--     grt: type definition / gO: document symbols / [d ]d: 前後の診断 / <C-w>d: 診断の詳細
--     挿入モード <C-s>: signature help
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
  end,
})

-- ============================================================================
-- 補完エンジン（settings.lua の vim.g.completion_engine で切り替え）
--   "blink" / "cmp" / "native" を実際に試して比較し、気に入った方に決めたら
-- 不要なプラグインを plugins.lua から削除する。
-- ============================================================================
local engine = vim.g.completion_engine

-- blink.cmp: capabilities を取得する前に setup しておく
if engine == "blink" then
pcall(function()
  require("blink.cmp").setup({
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
      default = { "lsp", "path", "snippets", "buffer" },  -- snippets は friendly-snippets を自動で読み込む
    },
    -- コマンドライン補完は従来どおり Vim 標準（wildmenu）を使う
    cmdline = { enabled = false },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  })
end)
end

-- capabilities: 補完エンジンに応じて構築
local capabilities
if engine == "blink" and pcall(require, "blink.cmp") then
  capabilities = require("blink.cmp").get_lsp_capabilities()
elseif engine == "cmp" and pcall(require, "cmp_nvim_lsp") then
  capabilities = require("cmp_nvim_lsp").default_capabilities()
else
  capabilities = vim.lsp.protocol.make_client_capabilities()
  -- ネイティブ補完でも LSP スニペット展開を受け取れるようにする
  capabilities.textDocument.completion.completionItem.snippetSupport = true
end

-- ネイティブ補完を有効化（engine = "native" のときのみ）
if engine == "native" then
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
    end,
  })
end

-- ============================================================================
-- LSP 設定（Neovim ネイティブ vim.lsp.config / vim.lsp.enable, 0.11+）
--   nvim-lspconfig が提供する lsp/*.lua プリセット（cmd/filetypes/root）に
--   設定を上乗せする。mason はサーバの「インストール」にのみ使う。
-- ============================================================================
local setup_lsp = function()
  -- mason: サーバのインストールのみ担当
  -- automatic_enable = false: v2 の自動有効化を切り、下の vim.lsp.enable で明示制御する
  -- （自動有効化だと ruff まで LSP として起動してしまうため）
  require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "ts_ls", "gopls", "lua_ls" },
    automatic_enable = false,
  })

  -- 全サーバ共通のデフォルト（キーマップは上の LspAttach で設定）
  vim.lsp.config("*", {
    capabilities = capabilities,
  })

  -- 個別設定（プリセットに上乗せされる）
  vim.lsp.config("pyright", {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  })

  vim.lsp.config("ts_ls", {
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
  })

  vim.lsp.config("gopls", {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })

  -- 有効化（ruff は nvim-lint で使うため LSP としては有効化しない）
  vim.lsp.enable({ "pyright", "ts_ls", "gopls", "lua_ls" })
end

-- LSP設定を実行
pcall(setup_lsp)

-- ============================================================================
-- nvim-cmp: 補完設定（engine = "cmp" のときのみ）
-- ============================================================================
if engine == "cmp" then
pcall(function()
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
end)
end -- if engine == "cmp"

-- ============================================================================
-- TreeSitter: 構文解析・ハイライト
-- ============================================================================
pcall(function()
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
  local ts_query = require("vim.treesitter.query")
  local md_lang_alias = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
  local function parser_from_info_string(alias)
    return vim.filetype.match({ filename = "a." .. alias }) or md_lang_alias[alias] or alias
  end
  ts_query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
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
end)

-- ============================================================================
-- conform.nvim: フォーマッター
-- ============================================================================
pcall(function()
  require("conform").setup({
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
    -- 保存時の自動フォーマットを無効化（Space+fで手動実行）
    -- format_on_save = {
    --   timeout_ms = 3000,
    --   lsp_fallback = true,
    -- },
  })
end)

-- ============================================================================
-- nvim-lint: リンター
-- ============================================================================
pcall(function()
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
      pcall(function()
        require("lint").try_lint()
      end)
    end,
  })
end)

-- ============================================================================
-- Gitsigns: Git統合
-- ============================================================================
pcall(function()
  require("gitsigns").setup({
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function opts(desc) return { buffer = bufnr, desc = desc } end

      -- Navigation
      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Next hunk" })

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Previous hunk" })

      -- Actions
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts("Stage hunk"))
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts("Reset hunk"))
      vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts("Undo stage hunk"))
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts("Preview hunk"))
      vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts("Blame line"))
      vim.keymap.set("n", "<leader>hd", gs.diffthis, opts("Diff this"))
    end
  })
end)

-- ============================================================================
-- その他のプラグイン設定
-- ============================================================================

-- nvim-autopairs: 括弧の自動補完
pcall(function()
  require("nvim-autopairs").setup({
    check_ts = true,
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
    },
  })

  -- nvim-cmpとの統合（blink.cmp は確定時の括弧補完を内蔵しているため不要）
  if engine ~= "cmp" then
    return
  end
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end)

-- flash.nvim: 高速移動
pcall(function()
  require("flash").setup({
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
  })
end)

-- yanky.nvim: ヤンク履歴
pcall(function()
  require("yanky").setup({
    highlight = {
      timer = 150,
    },
  })
end)

-- Comment.nvim: コメントアウト
pcall(function()
  require("Comment").setup()
end)

-- neo-tree.nvim: ファイルエクスプローラー
pcall(function()
  require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      indent = {
        padding = 0,
        with_markers = true,
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
      },
      git_status = {
        symbols = {
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        }
      },
    },
    window = {
      position = "left",
      width = 35,
      mappings = {
        -- h/l/Enter でナビゲーション
        ["h"] = "navigate_up",         -- 親ディレクトリに移動
        ["l"] = "open_tabnew",         -- ツリーを展開/新しいタブで開く
        ["<CR>"] = "open_tabnew",      -- Enter: 新しいタブで開く
        ["<Return>"] = "open_tabnew",  -- Return: 新しいタブで開く（念のため）
        ["o"] = "open",                -- 現在のバッファで開く
        ["<space>"] = "none",          -- スペースキーの誤操作を防ぐ
        ["<esc>"] = "revert_preview",
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["w"] = "open_with_window_picker",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["a"] = {
          "add",
          config = {
            show_path = "relative"
          }
        },
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
        ["/"] = "none",                -- /: vimネイティブ検索に委譲
        ["H"] = "toggle_hidden",       -- H: 隠しファイルの表示切り替え
      }
    },
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = true,
      },
      follow_current_file = {
        enabled = true,  -- 現在のファイルを追跡
        leave_dirs_open = false,
      },
      group_empty_dirs = false,
      hijack_netrw_behavior = "disabled",  -- ディレクトリを開いた時は oil.nvim に任せる
      use_libuv_file_watcher = true,
    },
    buffers = {
      follow_current_file = {
        enabled = true,
      },
    },
    git_status = {
      window = {
        position = "float",
      }
    }
  })
end)

-- which-key.nvim: 押しかけのキーに続く候補をポップアップ表示
--   :checkhealth which-key で重複・衝突しているキーマップも確認できる
pcall(function()
  local wk = require("which-key")
  wk.setup({ preset = "modern" })
  -- グループ名（<leader> の後に表示される見出し）
  wk.add({
    { "<leader>f", group = "Find / Format" },
    { "<leader>h", group = "Git hunk" },
    { "<leader>x", group = "Trouble" },
    { "gr", group = "LSP" },
    { "t", group = "Tab" },
  })
end)

-- oil.nvim: ディレクトリをバッファとして編集
--   行の書き換え → :w でリネーム、dd → :w で削除、yy/p → :w でコピー
--   主なキー: <CR> 開く, - 親ディレクトリ, _ cwd を開く, g. 隠しファイル切替, g? ヘルプ
pcall(function()
  require("oil").setup({
    default_file_explorer = true,  -- nvim . などディレクトリを開いた時も oil を使う
    view_options = {
      show_hidden = true,  -- neo-tree と同様にドットファイルも表示
    },
  })
end)

-- aerial.nvim: シンボルアウトライン
pcall(function()
  require("aerial").setup({
    backends = { "treesitter", "lsp" },
    layout = {
      min_width = 30,
    },
    attach_mode = "global",
  })
end)

-- toggleterm.nvim: ターミナル統合
pcall(function()
  require("toggleterm").setup({
    size = 20,
    open_mapping = [[<C-\>]],
    direction = "horizontal",
    close_on_exit = true,
  })
end)

-- nightfox
pcall(function()
  local nightfox = require("nightfox")
  nightfox.setup({
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
    paletts = {
      bg_alt = "#000000",
    },
    groups = {
      all = {
        TSPunctDelimiter = { fg = "palette.red" },
        LspCodeLens = { bg = "#000000", style = "italic" },
        TabLineSel = { bg = "palette.yellow", fg = "palette.black" },
      }
    },
  })
end)

-- lualine
pcall(function()
  require("lualine").setup({
    options = {
      theme = "nightfox"
    }
  })
end)

-- telescope fzf拡張
pcall(function()
  require("telescope").setup({
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }
    }
  })
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("yank_history")
end)

-- todo-comments.nvim: TODOコメント管理
pcall(function()
  require("todo-comments").setup({
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
  })
end)

-- カラースキームを duskfox に設定
vim.cmd.colorscheme("duskfox")

-- カーソルラインを明るくする設定（カラースキーム適用後）
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3c3c" })
