-- プラグイン個別設定

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
    "black",        -- Python
    "isort",        -- Python imports
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

-- 共通のon_attach関数
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- デバッグ: LSPクライアントが起動したことを通知
  vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)

  -- LSPキーマップ
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

-- Mason-LSPConfig: ハンドラーを使ってLSPサーバーを自動設定
local setup_lsp = function()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  require("mason-lspconfig").setup({
    ensure_installed = {
      "pyright",      -- Python
      "ts_ls",        -- TypeScript/JavaScript
      "gopls",        -- Go
      "lua_ls",       -- Lua (Neovim設定用)
    },
    automatic_installation = true,
  })

  -- ハンドラーを別途設定
  require("mason-lspconfig").setup_handlers({
      -- デフォルトハンドラー（全てのLSPサーバーに適用）
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end,

      -- 個別のLSPサーバー設定（カスタマイズが必要な場合）
      ["pyright"] = function()
        require("lspconfig").pyright.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              }
            }
          }
        })
      end,

      ["ts_ls"] = function()
        require("lspconfig").ts_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
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
              }
            }
          }
        })
      end,

      ["gopls"] = function()
        require("lspconfig").gopls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            }
          }
        })
      end,

      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            }
          }
        })
      end,
    })
end

-- LSP設定を実行
pcall(setup_lsp)

-- ============================================================================
-- nvim-cmp: 補完設定
-- ============================================================================
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
end)

-- ============================================================================
-- conform.nvim: フォーマッター
-- ============================================================================
pcall(function()
  require("conform").setup({
    formatters_by_ft = {
      python = { "black", "isort" },
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
      local opts = { buffer = bufnr }

      -- Navigation
      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr })

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr })

      -- Actions
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
      vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
      vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
      vim.keymap.set("n", "<leader>hd", gs.diffthis, opts)
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

  -- nvim-cmpとの統合
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

-- indent-blankline.nvim: インデントガイド
pcall(function()
  require("ibl").setup({
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = false,
    },
  })
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
      hijack_netrw_behavior = "open_default",
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

-- nvim-notify: 通知UI改善
pcall(function()
  local notify = require("notify")
  notify.setup({
    stages = "fade_in_slide_out",
    timeout = 3000,
    background_colour = "#000000",
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
  })
  -- デフォルトの通知をnvim-notifyに置き換え
  vim.notify = notify
end)

-- dressing.nvim: select/input UI改善（Telescope統合）
pcall(function()
  require("dressing").setup({
    input = {
      enabled = true,
      default_prompt = "Input:",
      prompt_align = "left",
      insert_only = true,
      start_in_insert = true,
      border = "rounded",
      relative = "cursor",
      prefer_width = 40,
      width = nil,
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },
    },
    select = {
      enabled = true,
      backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
      telescope = require("telescope.themes").get_dropdown({
        layout_config = {
          width = 0.8,
          height = 0.8,
        },
      }),
    },
  })
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
