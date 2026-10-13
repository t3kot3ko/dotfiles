# Neovim設定

モダンなNeovim設定ファイル（Python, TypeScript, Go向け）

## 特徴

### LSP・補完
- **LSP**: Neovim ネイティブの `vim.lsp.config` / `vim.lsp.enable`（nvim-lspconfig はプリセットの供給元として利用）
  - Python (pyright), TypeScript (ts_ls), Go (gopls), Lua (lua_ls)
- **Mason**: LSPサーバー、フォーマッター、リンターのインストール管理
- **lazydev.nvim**: Neovim の Lua 設定を書くときに、`vim.*` やプラグインの型定義を lua_ls に渡す
- **blink.cmp**: 補完（LSP / パス / バッファ / スニペット、シグネチャ表示）
  - `lua/config/options.lua` の `vim.g.completion_engine` で `"blink"` / `"cmp"`（nvim-cmp）/ `"native"` を切り替え可能

### フォーマット・リント
- **conform.nvim**: 手動フォーマット（`<leader>fm`）
  - Python: ruff_format
  - TypeScript/JavaScript/Markdown: prettier
  - Go: gofumpt, goimports
  - Lua: stylua
- **nvim-lint**: リアルタイムリント
  - Python: ruff
  - TypeScript/JavaScript: eslint_d
  - Go: golangci-lint

### UI
- **nightfox.nvim**: カラースキーム（duskfox）
- **lualine.nvim**: ステータスライン
- **snacks.nvim**: 通知、入力UI（`vim.ui.input`）、選択UI（`vim.ui.select`）、インデントガイド
- **which-key.nvim**: 押しかけのキーに続く候補をポップアップ表示
- **nvim-treesitter**: 構文ハイライト・コード解析

### ファイル管理・検索
- **oil.nvim**: ディレクトリをバッファとして編集（リネーム・削除・コピーを編集 → `:w` で実行）
- **neo-tree.nvim**: ファイルツリー
- **telescope.nvim**: ファジーファインダー
- **aerial.nvim**: シンボルアウトライン
- **vim-eunuch**: `:Rename` / `:Move` / `:Delete` などのファイル操作コマンド

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

```bash
nvim
```

初回起動時に以下が自動で行われます：

1. lazy.nvim がプラグインをインストール
2. Mason がツールをインストール
   - フォーマッター: prettier, gofumpt, goimports, stylua
   - リンター: ruff, eslint_d, golangci-lint
3. mason-lspconfig が LSP サーバーをインストール: pyright, ts_ls, gopls, lua_ls
4. TreeSitter のパーサーをインストール: python, typescript, javascript, go, lua, markdown

## 主要キーマップ

リーダーキーは `<Space>`。キーを押して少し待つと which-key が続きのキーを表示します。

### バッファ・タブ
- `<Tab>` / `<S-Tab>`: 次/前のバッファ
- `tc`: 新しいタブ / `tx`: タブを閉じる
- `tn` / `tl`: 次のタブ / `tp` / `th`: 前のタブ

### ファイル操作
- `-`: oil で現在のファイルのディレクトリを開く（oil 内で `-` を押すとさらに親へ）
- `<leader>e`: Neo-tree トグル
- `<leader>ff`: ファイル検索 / `<leader>fg`: grep検索 / `<leader>fb`: バッファ一覧
- `<leader>fr`: 最近使ったファイル / `<leader>fc`: コマンド一覧 / `<leader>fh`: ヘルプ
- `<leader>fk`: キーマップ一覧（snacks picker）

**oil 内のキーマップ:** `<CR>` 開く、`-` 親ディレクトリ、`_` cwd を開く、`g.` 隠しファイル切替、
`<C-s>` 垂直分割で開く、`<C-t>` タブで開く、`<C-p>` プレビュー、`g?` ヘルプ

**Neo-tree 内のキーマップ:** `Enter` / `l` 新しいタブで開く、`o` 現在のバッファで開く、`h` 親ディレクトリ、
`s` / `S` 垂直/水平分割、`a` / `A` ファイル/ディレクトリ作成、`d` 削除、`r` リネーム、`q` 閉じる

### LSP（Neovim 標準キー + `gd` / `gD`）
- `gd`: 定義へジャンプ / `gD`: 宣言へジャンプ（`<C-]>` でも定義へジャンプ）
- `K`: ホバー情報
- `grn`: リネーム / `gra`: コードアクション / `grr`: 参照一覧
- `gri`: 実装へジャンプ / `grt`: 型定義へジャンプ / `gO`: シンボル一覧
- `<C-k>`: シグネチャヘルプ（挿入モードでは blink.cmp が自動表示、`<C-s>` でも表示）
- `[d` / `]d`: 前/次の診断
- `<leader>d`: 診断を浮動ウィンドウで表示 / `<leader>q`: 診断をロケーションリストへ
- `<leader>fm`: フォーマット

### 補完（blink.cmp）
- `<Tab>` / `<S-Tab>`: 候補の選択、スニペット内の移動
- `<CR>`: 確定（未選択なら先頭の候補）
- `<C-Space>`: 補完を表示 / `<C-e>`: 閉じる / `<C-b>` / `<C-f>`: ドキュメントのスクロール

### 移動（flash.nvim）
- `s`: Flash検索（検索パターン入力 → ラベルでジャンプ）
- `S`: Flash Treesitter（構文ツリーベース移動）
- `f{char}` / `t{char}`: 拡張文字検索（該当文字にラベル表示）

### ヤンク履歴
- `p` / `P`: ペースト（ヤンク履歴対応）
- `<C-n>` / `<C-p>`: ヤンク履歴を前後にサイクル
- `<leader>p`: ヤンク履歴をTelescopeで表示

### Git
- `]c` / `[c`: 次/前のハンク
- `<leader>hs`: ハンクをステージ（ステージ済みなら取り消し）
- `<leader>hr`: ハンクをリセット / `<leader>hp`: プレビュー
- `<leader>hb`: blame表示 / `<leader>hd`: diff表示
- `:G`: fugitive のステータス画面

### TODO コメント
- `<leader>ft`: TODOコメント検索 / `<leader>fT`: TODO/FIX/FIXMEを検索
- `]t` / `[t`: 次/前のTODOコメント

### その他
- `<leader>a`: Aerial（シンボルアウトライン）トグル
- `<leader>xx` / `<leader>xd`: Trouble（全体 / 現在のバッファの診断）
- `<leader>xl` / `<leader>xq`: Trouble（ロケーションリスト / クイックフィックス）
- `<leader>r`: 現在のファイルを実行
- `<leader>n`: 通知履歴
- `<C-\>`: ターミナルトグル
- `gcc`: 行コメントトグル / `gc`: ビジュアルモードでコメントトグル

## ファイル構造

```
.
├── init.lua                 # エントリーポイント
├── lua/
│   ├── config/
│   │   ├── options.lua      # 基本設定（リーダーキー、補完エンジンの選択）
│   │   ├── keymaps.lua      # キーマップ
│   │   └── lazy.lua         # lazy.nvim のセットアップ
│   └── plugins/             # プラグイン定義と設定（lazy.nvim の spec。1 ファイル = 1 分野）
│       ├── colorscheme.lua
│       ├── ui.lua           # snacks, lualine, which-key
│       ├── editor.lua       # autopairs, surround, flash, yanky, Comment, todo-comments
│       ├── lsp.lua          # mason, LSP, 診断, lazydev
│       ├── completion.lua   # blink.cmp / nvim-cmp
│       ├── formatting.lua   # conform, nvim-lint
│       ├── treesitter.lua
│       ├── files.lua        # oil, neo-tree, telescope, aerial, vim-eunuch
│       ├── git.lua          # gitsigns, fugitive
│       └── tools.lua        # trouble, toggleterm
└── README.md
```

プラグインの設定は lazy.nvim の `opts` / `config` に書いているため、
`cmd` / `event` / `keys` で指定したタイミングまで読み込まれません（起動の高速化）。

## トラブルシューティング

### LSPが動作しない
1. Masonでサーバーがインストールされているか確認：`:Mason`
2. LSPの状態を確認：`:checkhealth vim.lsp`
3. LSP通知を確認（起動時に"LSP attached: ..."と表示される。`<leader>n` で履歴）

### フォーマッターが動作しない
1. Masonでフォーマッターがインストールされているか確認：`:Mason`
2. conform.nvimの設定を確認：`:ConformInfo`

### 補完が表示されない
1. blink.cmp の状態を確認：`:checkhealth blink.cmp`
2. LSPが起動しているか確認：`:checkhealth vim.lsp`

### キーマップが効かない・衝突している
- `:checkhealth which-key`: 重複・衝突しているキーマップを表示
- `:verbose nmap <キー>`: そのキーがどこで定義されたかを表示

### プラグインの管理
- `:Lazy`: プラグイン管理画面を開く
- `:Lazy sync`: プラグインの同期（インストール/更新/削除）
- `:Lazy clean`: 不要なプラグインを削除
- `:Lazy update`: プラグインを更新

## 必要な外部ツール

- **cmake**: telescope-fzf-native.nvimのビルドに必要
- **ripgrep**: Telescope の live_grep と todo-comments の検索に必要
- その他のツール（LSP、フォーマッター、リンター）はMasonで自動インストール

## カスタマイズ

- **キーマップ**: `lua/config/keymaps.lua`
- **基本設定**: `lua/config/options.lua`
- **プラグイン追加・設定**: `lua/plugins/` 以下の該当ファイル（新しいファイルを置けば自動で読み込まれる）
- **カラースキーム**: `lua/plugins/colorscheme.lua`
