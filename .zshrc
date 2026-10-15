# Alias
[ -e ~/.zshrc.alias ] && source ~/.zshrc.alias

# brew --prefix を呼ぶと毎回 40ms ほどかかるため、brew の実体の場所（<prefix>/bin/brew）から求める
if (( $+commands[brew] )); then
    FPATH="${commands[brew]:h:h}/share/zsh/site-functions:${FPATH}"
fi

fpath=(~/.local/share/sheldon/repos/github.com/mollifier/cd-gitroot $fpath)
autoload -Uz cd-gitroot


# Initialize completion system (optimized for performance)
# Only regenerate .zcompdump once a day
#   [[ -n file(#q...) ]] の中ではグロブが展開されず条件が常に真になるため、無名関数の引数で判定する
#   （24 時間以上前のダンプがあれば $# = 1）。ダンプが無いときは compinit -C でも新規作成される
#   内容が変わらないと compinit はダンプを書き直さず mtime が古いままになるので、touch で更新する
autoload -Uz compinit
() {
  if (( $# )); then
    compinit && touch "$1"
  else
    compinit -C
  fi
} ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24)  # compinit の既定の保存先と同じ

# Plugins (Sheldon)
eval "$(sheldon source)"

# atuin（履歴検索, Ctrl-R）
#   sheldon でリポジトリを clone せず、brew でインストールした本体の初期化スクリプトを使う（本体とバージョンが揃う）
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh)"
fi

# Esc の誤解釈を防ぐため、タイムアウトを短縮（デフォルト 400ms → 50ms）
KEYTIMEOUT=5

# Restore up/down arrow and vim j/k to history navigation (override atuin's binding)
# ^[[A (通常カーソルキー) と ^[OA (Application cursor mode) の両方を上書きして統一する
bindkey -M viins '^[[A' history-beginning-search-backward
bindkey -M viins '^[[B' history-beginning-search-forward
bindkey -M viins '^[OA' history-beginning-search-backward
bindkey -M viins '^[OB' history-beginning-search-forward
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward

# Ctrl+A: move cursor to end of line (override completion insert in vi mode)
bindkey -M viins '^A' end-of-line
bindkey -M vicmd '^A' end-of-line

# Esc → vi normal mode: BUFFER を一切変更せず直接キーマップを切り替える
# vi-cmd-mode は FSH 等のプラグインにラップされており、
# そのラッパーが BUFFER をクリアする副作用を持つ場合がある。
# zle -K vicmd を使うことでラッパーを完全にバイパスする。
function _zle_vi_escape() {
  [[ $CURSOR -gt 0 ]] && (( CURSOR-- ))
  zle -K vicmd
}
zle -N _zle_vi_escape
bindkey -M viins '\e' _zle_vi_escape


# Development
[ -e ~/.zshrc.dev ] && source ~/.zshrc.dev

# Custom
[ -e ~/.zshrc.custom ] && source ~/.zshrc.custom

# fzf custom commands
if (( $+commands[fzf] )) && [ -e $HOME/.zshrc.fzf  ]; then
	source $HOME/.zshrc.fzf
fi

# tmux
[ -e ~/.zshrc.tmux ] && source ~/.zshrc.tmux

# Alias (loaded after plugins installed)
[ -e ~/.zshrc.alias.lazy ] && source ~/.zshrc.alias.lazy

# Local settings (not version controlled)
[ -e ~/.zshrc.local ] && source ~/.zshrc.local

# asdf
export ASDF_DATA_DIR="${HOME}/.asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Prompt (Starship)
eval "$(starship init zsh)"
# 右プロンプトは zsh の書式だけで表示する（starship を右用に起動しないので、プロンプトごとの starship の起動が 1 回で済む）
#   2 秒以上かかったときの実行時間（took 1m5s など）、失敗したときの終了コード（✘127 など）、
#   バックグラウンドのジョブ数（✦1）、フルパスの順。前の 3 つは該当するときだけ出る
zmodload zsh/datetime
autoload -Uz add-zsh-hook
function _cmd_duration_preexec() { _cmd_start=$EPOCHREALTIME }
function _cmd_duration_precmd() {
  _cmd_took=
  [[ -n $_cmd_start ]] || return
  local -i s=$(( EPOCHREALTIME - _cmd_start ))
  _cmd_start=
  (( s >= 2 )) || return
  local t
  (( s >= 3600 )) && t+="$(( s / 3600 ))h"
  (( s >= 60 )) && t+="$(( s % 3600 / 60 ))m"
  t+="$(( s % 60 ))s"
  _cmd_took="%F{yellow}took $t%f "
}
add-zsh-hook preexec _cmd_duration_preexec
add-zsh-hook precmd _cmd_duration_precmd
RPROMPT='${_cmd_took}%(?..%F{red}✘%?%f )%(1j.%F{yellow}✦%j%f .)[%~]'
# Enter を押したら、それまでの行の右プロンプトを消す（出力をコピーしたときにパスが混ざらないように）
setopt transient_rprompt

# zoxide (https://github.com/ajeetdsouza/zoxide)
eval "$(zoxide init zsh --cmd d)"
export _ZO_FZF_OPTS=${FZF_DEFAULT_OPTS}

