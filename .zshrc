# Customize to your needs...
source ~/.zshrc.custom
if [ -e ~/.zshrc.alias ]; then
	source ~/.zshrc.alias
fi

if [ -e ~/.zshrc.tmp ]; then
	source ~/.zshrc.tmp
fi
source ~/.zshrc.zplug

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
