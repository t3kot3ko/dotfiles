source ~/.zshrc.custom

[ -e ~/.zshrc.alias ] && source ~/.zshrc.tmp
[ -e ~/.zshrc.tmp ] && source ~/.zshrc.tmp
[ -e ~/.zshrc.dev ] && source ~/.zshrc.dev

source ~/.zshrc.zplug

