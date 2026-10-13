-- 基本設定（リーダーキーと補完エンジンの選択を含むため、プラグインより先に読み込む）
require("config.options")

-- キーマッピング
require("config.keymaps")

-- プラグイン管理（lazy.nvim）。各プラグインの設定は lua/plugins/*.lua に置く
require("config.lazy")
