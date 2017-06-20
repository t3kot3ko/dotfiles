source ~/.zshrc.custom

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -e ~/.zshrc.alias ] && source ~/.zshrc.alias
[ -e ~/.zshrc.tmp ] && source ~/.zshrc.tmp
[ -e ~/.zshrc.dev ] && source ~/.zshrc.dev
[ -e ~/.zshrc.fzf ] && source ~/.zshrc.fzf

source ~/.zshrc.zplug
