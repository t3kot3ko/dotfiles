# Alias
[ -e ~/.zshrc.alias ] && source ~/.zshrc.alias

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit && compinit
fi

# Plugins (Sheldon)
# autoload -Uz compinit && compinit
eval "$(sheldon source)"

# asdf
source /opt/homebrew/opt/asdf/libexec/asdf.sh

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

# Prompt (Starship)
eval "$(starship init zsh)"

