if [[ -n ${SSH_TTY} ]]; then
	tmux source ${HOME}/.tmux.green.conf

	# Set G as prefix
	tmux set -g prefix C-g;
	tmux unbind C-t
	tmux bind C-g last-window
	
else
	tmux source ${HOME}/.tmux.blue.conf

	# Set G as prefix
	tmux set -g prefix C-t;
	tmux unbind C-t
	tmux bind C-t last-window
fi

# Start tmux at the same time when new shell session starts

if [[ ! -n $TMUX && $TERM_PROGRAM != "vscode" ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | fzf | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID" -d
  else
    :  # Start terminal normally
  fi
fi

