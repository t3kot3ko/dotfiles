-- Neovide GUI 専用設定
-- vim.g.neovide は Neovide 起動時のみ true になる
if not vim.g.neovide then
  return
end

-- ============================================================================
-- カラースキーム（plugin-config.lua の duskfox 設定を上書き）
-- ============================================================================
pcall(function()
  require("catppuccin").setup({
    flavour = "latte",
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      cmp = true,
      gitsigns = true,
      telescope = { enabled = true },
      neotree = true,
      indent_blankline = { enabled = true },
      lualine = true,
      flash = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")

  -- lualine のテーマも catppuccin に揃える
  require("lualine").setup({
    options = {
      theme = "catppuccin-nvim",
    },
  })
end)

-- ============================================================================
-- フォント
-- ============================================================================
vim.o.guifont = "Hack Nerd Font Mono:h16"

-- ============================================================================
-- 外観
-- ============================================================================
-- ウィンドウ不透明度（0.0〜1.0）
vim.g.neovide_opacity = 1.0

-- 背景色の不透明度（透過と組み合わせて使う）
vim.g.neovide_background_color = "#1e1e2e"

-- パディング
vim.g.neovide_padding_top = 4
vim.g.neovide_padding_bottom = 4
vim.g.neovide_padding_left = 8
vim.g.neovide_padding_right = 8

-- ============================================================================
-- カーソル
-- ============================================================================
-- カーソル移動アニメーションの長さ（秒）。0 で無効
vim.g.neovide_cursor_animation_length = 0

-- スムーズカーソルの速さ（大きいほど速い）
vim.g.neovide_cursor_smooth_blink = false

-- カーソルエフェクト: "" | "railgun" | "torpedo" | "pixiedust" | "sonicboom" | "ripple" | "wireframe"
vim.g.neovide_cursor_vfx_mode = ""

-- ============================================================================
-- スクロール
-- ============================================================================
vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_scroll_animation_far_lines = 1

-- ============================================================================
-- macOS 固有
-- ============================================================================
-- Cmd キーをリーダー等に使えるようにする
vim.g.neovide_input_use_logo = true

-- Option キーを Meta として扱う
vim.g.neovide_input_macos_alt_is_meta = false

-- フルスクリーン
vim.g.neovide_fullscreen = false

-- ============================================================================
-- キーマッピング（Neovide 専用）
-- ============================================================================
local map = function(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Cmd+V でペースト
map("n", "<D-v>", '"+p')
map("i", "<D-v>", '<C-r>+')
map("c", "<D-v>", '<C-r>+')
map("t", "<D-v>", '<C-\\><C-n>"+pi')

-- Cmd+C でコピー
map("v", "<D-c>", '"+y')

-- Cmd+S で保存
map("n", "<D-s>", "<cmd>w<cr>")
map("i", "<D-s>", "<esc><cmd>w<cr>")

-- Cmd+W でウィンドウを閉じる
map("n", "<D-w>", "<cmd>close<cr>")

-- Cmd++ / Cmd+- でフォントサイズ変更
local function change_font_size(delta)
  local font = vim.o.guifont
  local name, size = font:match("^(.+):h(%d+)$")
  if name and size then
    vim.o.guifont = name .. ":h" .. tostring(tonumber(size) + delta)
  end
end

map("n", "<D-=>", function() change_font_size(1) end)
map("n", "<D-->", function() change_font_size(-1) end)
map("n", "<D-0>", function() vim.o.guifont = "Hack Nerd Font Mono:h16" end)
