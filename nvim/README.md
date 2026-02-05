# Neovim設定

モダンなNeovim設定ファイル（Python, TypeScript, Go向け）

## 特徴

### LSP・補完
- **Mason**: LSPサーバー、フォーマッター、リンターの統合管理
- **nvim-lspconfig**: Python (pyright), TypeScript (ts_ls), Go (gopls), Lua (lua_ls)
- **nvim-cmp**: LSP補完 + LuaSnip統合
- **LuaSnip**: スニペットエンジン
- **lsp_signature.nvim**: 関数シグネチャのヘルプ表示

### フォーマット・リント
- **conform.nvim**: 手動フォーマット（`<leader>fm`）
  - Python: black, isort
  - TypeScript/JavaScript: prettier
  - Go: gofumpt, goimports
  - Lua: stylua
- **nvim-lint**: リアルタイムリント
  - Python: ruff
  - TypeScript/JavaScript: eslint_d
  - Go: golangci-lint

### UI・編集支援
- **lualine.nvim**: ステータスライン
- **nvim-notify**: 通知UI改善
- **dressing.nvim**: 入力UIの改善（Telescope統合）
- **indent-blankline.nvim**: インデントガイド
- **nvim-treesitter**: 構文ハイライト・コード解析
- **gitsigns.nvim**: Git統合（差分表示、ハンクナビゲーション、blame）

### ファイル管理・検索
- **neo-tree.nvim**: ファイルツリー
- **telescope.nvim**: ファジーファインダー
- **aerial.nvim**: シンボルアウトライン

### 編集支援
- **nvim-autopairs**: 括弧自動補完
- **nvim-surround**: 囲み文字操作
- **flash.nvim**: 高速移動（f/t拡張、検索ジャンプ）
- **yanky.nvim**: ヤンク履歴管理
- **Comment.nvim**: コメントアウト
- **todo-comments.nvim**: TODOコメントのハイライトと管理

### Git
- **gitsigns.nvim**: Git差分表示、ハンク操作
- **vim-fugitive**: Git操作コマンド

### その他
- **toggleterm.nvim**: ターミナル統合
- **trouble.nvim**: 診断表示

## 初回セットアップ

### 1. Neovimを起動

```bash
nvim
```

初回起動時、lazy.nvimが自動的にプラグインをインストールします。

### 2. 必要なツールの自動インストール

初回起動時にMasonが以下のツールを自動インストールします：

**フォーマッター:**
- black, isort (Python)
- prettier (TypeScript/JavaScript/Markdown)
- gofumpt, goimports (Go)
- stylua (Lua)

**リンター:**
- ruff (Python)
- eslint_d (TypeScript/JavaScript)
- golangci-lint (Go)

### 3. LSPサーバーの自動インストール

以下のLSPサーバーが自動インストールされます：
- pyright (Python)
- ts_ls (TypeScript/JavaScript)
- gopls (Go)
- lua_ls (Lua)

### 4. TreeSitterのパーサー

以下の言語のパーサーが自動インストールされます：
- python, typescript, javascript, go, lua, markdown

## 主要キーマップ

### リーダーキー
デフォルトは `\` (バックスラッシュ)

### バッファ操作
- `<Tab>` / `<S-Tab>`: 次/前のバッファに移動

### ファイル操作
- `-`: Neo-tree トグル
- `<leader>ff`: ファイル検索 (Telescope)
- `<leader>fg`: grep検索 (Telescope)
- `<leader>fb`: バッファ一覧 (Telescope)
- `<leader>fr`: 最近使ったファイル (Telescope)
- `<leader>fc`: コマンド一覧 (Telescope)

**Neo-tree内のキーマップ:**
- `Enter`: ファイルを新しいタブで開く
- `l`: ディレクトリを展開/ファイルを開く
- `o`: 現在のバッファで開く
- `h`: 親ディレクトリに移動
- `s`: 垂直分割で開く
- `S`: 水平分割で開く
- `t`: 新しいタブで開く
- `a`: ファイル作成
- `A`: ディレクトリ作成
- `d`: 削除
- `r`: リネーム
- `q`: 閉じる

### LSP
- `gd`: 定義へジャンプ
- `gD`: 宣言へジャンプ
- `gi`: 実装へジャンプ
- `gr`: 参照を表示
- `gt`: 型定義へジャンプ
- `K`: ホバー情報
- `gh`: シグネチャヘルプ
- `<C-k>`: シグネチャヘルプ
- `<leader>rn`: リネーム
- `<leader>ca`: コードアクション
- `<leader>fm`: フォーマット
- `[d` / `]d`: 前/次の診断
- `<leader>d`: 診断を浮動ウィンドウで表示
- `<leader>q`: 診断をロケーションリストに追加

### 移動（flash.nvim）
- `s`: Flash検索（検索パターン入力 → ラベルでジャンプ）
- `S`: Flash Treesitter（構文ツリーベース移動）
- `f{char}`: 拡張文字検索（該当文字にラベル表示）
- `t{char}`: 拡張文字検索（該当文字の前にラベル表示）

### ヤンク履歴
- `p` / `P`: ペースト（ヤンク履歴対応）
- `<C-n>` / `<C-p>`: ヤンク履歴を前後にサイクル
- `<leader>p`: ヤンク履歴をTelescopeで表示

### Git
- `]c` / `[c`: 次/前のハンク
- `<leader>hs`: ハンクをステージ
- `<leader>hr`: ハンクをリセット
- `<leader>hu`: ハンクのステージを取り消し
- `<leader>hp`: ハンクをプレビュー
- `<leader>hb`: blame表示
- `<leader>hd`: diff表示

### タブ操作
- `tc`: 新しいタブを作成
- `tx`: タブを閉じる
- `tn` / `tl`: 次のタブ
- `tp` / `th`: 前のタブ

### TODO コメント
- `<leader>ft`: TODOコメント検索 (Telescope)
- `<leader>fT`: TODO/FIX/FIXMEを検索
- `]t` / `[t`: 次/前のTODOコメント

### その他
- `<leader>a`: Aerial（シンボルアウトライン）トグル
- `<leader>xx`: Trouble（診断一覧）トグル
- `<leader>xd`: Trouble（現在のバッファの診断）
- `<leader>xl`: Trouble（ロケーションリスト）
- `<leader>xq`: Trouble（クイックフィックス）
- `<leader>r`: 現在のファイルを実行
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
│   └── lsp-debug.lua     # LSPデバッグ用
└── README.md             # このファイル
```

## トラブルシューティング

### LSPが動作しない
1. Masonでサーバーがインストールされているか確認：`:Mason`
2. LSPクライアントが起動しているか確認：`:LspInfo`
3. LSP通知を確認（起動時に"LSP attached: ..."と表示される）

### フォーマッターが動作しない
1. Masonでフォーマッターがインストールされているか確認：`:Mason`
2. conform.nvimの設定を確認：`:ConformInfo`

### 補完が表示されない
1. nvim-cmpが読み込まれているか確認：`:lua print(vim.inspect(require('cmp')))`
2. LSPが起動しているか確認：`:LspInfo`

### プラグインの管理
- `:Lazy`: プラグイン管理画面を開く
- `:Lazy sync`: プラグインの同期（インストール/更新/削除）
- `:Lazy clean`: 不要なプラグインを削除
- `:Lazy update`: プラグインを更新

## 必要な外部ツール

- **cmake**: telescope-fzf-native.nvimのビルドに必要
- その他のツール（LSP、フォーマッター、リンター）はMasonで自動インストール

## カスタマイズ

各ファイルを編集してカスタマイズできます：

- **キーマップ**: `lua/keymaps.lua`
- **基本設定**: `lua/settings.lua`
- **プラグイン追加**: `lua/plugins.lua`
- **プラグイン設定**: `lua/plugin-config.lua`

## カラースキーム

デフォルトは **duskfox**（nightfox.nvimテーマ）を使用しています。
変更する場合は `lua/plugin-config.lua` の最終行を編集してください。
