source ~/.zshrc.custom

[ -e ~/.zshrc.alias ] && source ~/.zshrc.tmp
[ -e ~/.zshrc.tmp ] && source ~/.zshrc.tmp
[ -e ~/.zshrc.dev ] && source ~/.zshrc.dev
[ -e ~/.zshrc.fzf ] && source ~/.zshrc.fzf

source ~/.zshrc.zplug

