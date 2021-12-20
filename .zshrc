[ -e ~/.zshrc.alias ] && source ~/.zshrc.alias
[ -e ~/.zshrc.alias.lazy ] && source ~/.zshrc.alias.lazy
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -e ~/.zshrc.tmp ] && source ~/.zshrc.tmp
[ -e ~/.zshrc.zinit ] && source ~/.zshrc.zinit
[ -e ~/.zshrc.dev ] && source ~/.zshrc.dev
source ~/.zshrc.custom

# fzf
if $(whence fzf > /dev/null) && [ -e $HOME/.zshrc.fzf  ]; then
	source $HOME/.zshrc.fzf
fi

[ -e ~/.zshrc.tmux ] && source ~/.zshrc.tmux
[ -e ~/.zshrc.local ] && source ~/.zshrc.local

# TODO: extract OS dependent settings
if [ `uname` = "Linux" ]; then
	# set key-repeat for Ubuntu (GUI setting is ignored)
	if [ $DISPLAY ]; then
		xset r rate 230 60
	fi
	[ -e $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap
fi
