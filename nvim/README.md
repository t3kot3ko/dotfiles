# Neovim設定

モダンなNeovim設定ファイル（Python, TypeScript, Go向け）

## 特徴

### LSP・補完
- **Mason**: LSPサーバー、フォーマッター、リンターの統合管理
- **nvim-lspconfig**: Python (pyright), TypeScript (ts_ls), Go (gopls), Lua (lua_ls)
- **nvim-cmp**: LSP補完 + LuaSnip統合
- **LuaSnip**: スニペットエンジン

### フォーマット・リント
- **conform.nvim**: 保存時自動フォーマット
  - Python: black, isort
  - TypeScript/JavaScript: prettier
  - Go: gofumpt, goimports
  - Lua: stylua
- **nvim-lint**: リアルタイムリント
  - Python: ruff
  - TypeScript/JavaScript: eslint_d
  - Go: golangcilint

### UI・編集支援
- **bufferline.nvim**: バッファライン表示
- **lualine.nvim**: ステータスライン
- **indent-blankline.nvim**: インデントガイド
- **nvim-treesitter**: 構文ハイライト・コード解析
- **gitsigns.nvim**: Git統合（差分表示、ハンクナビゲーション）
- **which-key.nvim**: キーバインドヘルプ

### ファイル管理・検索
- **neo-tree.nvim**: ファイルツリー
- **telescope.nvim**: ファジーファインダー
- **aerial.nvim**: シンボルアウトライン

### 編集支援
- **nvim-autopairs**: 括弧自動補完
- **nvim-surround**: 囲み文字操作
- **flash.nvim**: 高速移動
- **yanky.nvim**: ヤンク履歴管理
- **Comment.nvim**: コメントアウト

### その他
- **toggleterm.nvim**: ターミナル統合
- **trouble.nvim**: 診断表示
- **copilot.lua**: GitHub Copilot

## 初回セットアップ

### 1. Neovimを起動

```bash
nvim
```

初回起動時、lazy.nvimが自動的にプラグインをインストールします。

### 2. Masonでツールをインストール

Neovim内で以下を実行：

```vim
:MasonInstallAll
```

または、個別にインストール：

```vim
:MasonInstall pyright ts_ls gopls lua_ls
:MasonInstall black isort prettier gofumpt goimports stylua
:MasonInstall ruff eslint_d golangcilint
```

### 3. TreeSitterのパーサーをインストール

```vim
:TSInstall python typescript javascript go lua markdown
```

## 主要キーマップ

### リーダーキー
デフォルトは `\` (バックスラッシュ)

### バッファ操作
- `<Tab>` / `<S-Tab>`: 次/前のバッファ
- `<leader>bc`: バッファを選択して閉じる
- `<leader>bp`: バッファを選択して移動
- `<leader>bh` / `<leader>bl`: 左/右のバッファを全て閉じる

### ファイル操作
- `ff`: Neo-tree トグル
- `<leader>ff`: ファイル検索 (Telescope)
- `<leader>fg`: grep検索 (Telescope)
- `<leader>fb`: バッファ一覧 (Telescope)
- `<leader>fr`: 最近使ったファイル (Telescope)

### LSP
- `gd`: 定義へジャンプ
- `gD`: 宣言へジャンプ
- `gi`: 実装へジャンプ
- `gr`: 参照を表示
- `K`: ホバー情報
- `<leader>rn`: リネーム
- `<leader>ca`: コードアクション
- `<leader>f`: フォーマット
- `[d` / `]d`: 前/次の診断
- `<leader>e`: 診断を浮動ウィンドウで表示

### 移動
- `s`: Flash（高速移動）
- `S`: Flash Treesitter（構文ツリーベース移動）

### ヤンク履歴
- `p` / `P`: ペースト（ヤンク履歴対応）
- `<C-n>` / `<C-p>`: ヤンク履歴を前後にサイクル
- `<leader>p`: ヤンク履歴をTelescopeで表示

### Git
- `]c` / `[c`: 次/前のハンク
- `<leader>hs`: ハンクをステージ
- `<leader>hr`: ハンクをリセット
- `<leader>hp`: ハンクをプレビュー
- `<leader>hb`: blame表示
- `<leader>hd`: diff表示

### その他
- `<leader>a`: Aerial（シンボルアウトライン）トグル
- `<leader>xx`: Trouble（診断一覧）トグル
- `<leader>r`: QuickRun
- `<C-\>`: ターミナルトグル
- `gcc`: 行コメントトグル
- `gc`: ビジュアルモードでコメントトグル

## ファイル構造

```
.
├── init.lua              # エントリーポイント
├── lua/
│   ├── settings.lua      # 基本設定
│   ├── keymaps.lua       # キーマップ
│   ├── plugins.lua       # プラグイン定義
│   ├── plugin-config.lua # プラグイン設定
│   └── neovide.lua       # Neovide用設定
└── README.md             # このファイル
```

## トラブルシューティング

### LSPが動作しない
1. Masonでサーバーがインストールされているか確認：`:Mason`
2. LSPクライアントが起動しているか確認：`:LspInfo`

### フォーマッターが動作しない
1. Masonでフォーマッターがインストールされているか確認：`:Mason`
2. conform.nvimの設定を確認：`:ConformInfo`

### 補完が表示されない
1. nvim-cmpが読み込まれているか確認：`:lua print(vim.inspect(require('cmp')))`
2. LSPが起動しているか確認：`:LspInfo`

## 必要な外部ツール

- **Python**: black, isort, ruff (Masonで自動インストール)
- **TypeScript**: prettier, eslint_d (Masonで自動インストール)
- **Go**: gofumpt, goimports, golangcilint (Masonで自動インストール)
- **その他**: cmake (telescope-fzf-native.nvimのビルドに必要)

## カスタマイズ

各ファイルを編集してカスタマイズできます：

- **キーマップ**: `lua/keymaps.lua`
- **基本設定**: `lua/settings.lua`
- **プラグイン追加**: `lua/plugins.lua`
- **プラグイン設定**: `lua/plugin-config.lua`
