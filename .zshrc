source ~/.zshrc.zplug
source ~/.zshrc.custom

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -e ~/.zshrc.alias ] && source ~/.zshrc.alias
[ -e ~/.zshrc.tmp ] && source ~/.zshrc.tmp
[ -e ~/.zshrc.dev ] && source ~/.zshrc.dev
[ -e ~/.zshrc.tmux ] && source ~/.zshrc.tmux

# fzf
if $(whence fzf > /dev/null) && [ -e $HOME/.zshrc.fzf  ]; then
	source $HOME/.zshrc.fzf
fi

[ -e ~/.zshrc.local ] && source ~/.zshrc.local

