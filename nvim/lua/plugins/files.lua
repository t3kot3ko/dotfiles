-- ファイル管理・検索
return {
  -- oil.nvim: ディレクトリをバッファとして編集（netrw の代替。ディレクトリを開いた時に効くよう遅延読み込みしない）
  --   行の書き換え → :w でリネーム、dd → :w で削除、yy/p → :w でコピー
  --   主なキー: <CR> 開く, - 親ディレクトリ, _ cwd を開く, g. 隠しファイル切替, g? ヘルプ
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      default_file_explorer = true,  -- nvim . などディレクトリを開いた時も oil を使う
      view_options = {
        show_hidden = true,  -- neo-tree と同様にドットファイルも表示
      },
    },
  },

  -- neo-tree.nvim: ツリー表示のファイルエクスプローラー
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
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
          ["w"] = "none",                -- open_with_window_picker は nvim-window-picker が必要なため無効化
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
    },
  },

  -- telescope: ファジーファインダー
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })
      telescope.load_extension("fzf")
      telescope.load_extension("yank_history")
    end,
  },

  -- aerial.nvim: シンボルアウトライン
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      backends = { "treesitter", "lsp" },
      layout = {
        min_width = 30,
      },
      attach_mode = "global",
    },
  },

  -- ファイル操作（:Rename, :Move, :Delete 等）
  { "tpope/vim-eunuch", cmd = { "Rename", "Move", "Delete", "Mkdir", "Chmod", "SudoWrite" } },
}
