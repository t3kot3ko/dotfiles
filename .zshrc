# Alias
[ -e ~/.zshrc.alias ] && source ~/.zshrc.alias

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

fpath=(~/.local/share/sheldon/repos/github.com/mollifier/cd-gitroot $fpath)
autoload -Uz cd-gitroot


# Initialize completion system (optimized for performance)
# Only regenerate .zcompdump once a day
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# zsh-autosuggestions: limit search buffer to avoid lag on large history
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true

# Plugins (Sheldon)
eval "$(sheldon source)"

# Restore up/down arrow and vim j/k to history navigation (override atuin's binding)
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward

# Ctrl+A: move cursor to end of line (override completion insert in vi mode)
bindkey -M viins '^A' end-of-line
bindkey -M vicmd '^A' end-of-line


# Development
[ -e ~/.zshrc.dev ] && source ~/.zshrc.dev

# Custom
[ -e ~/.zshrc.custom ] && source ~/.zshrc.custom

# fzf custom commands
if $(whence fzf > /dev/null) && [ -e $HOME/.zshrc.fzf  ]; then
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
-

# Prompt (Starship)
eval "$(starship init zsh)"

# zoxide (https://github.com/ajeetdsouza/zoxide)
eval "$(zoxide init zsh --cmd d)"
export _ZO_FZF_OPTS=${FZF_DEFAULT_OPTS}

