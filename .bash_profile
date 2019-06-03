# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ./.{path,bash_prompt,exports,aliases,functions,extra,git-prompt.sh}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file" && echo $file;
done;
unset file;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	#export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

#https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux
source .tmux-completion.sh

###############################################
# Tmux
###############################################

if [ -z "$TMUX" ]; then
  if ( tmux has-session ); then
    tmux attach
  else
    # Create new session and detach
    tmux new -s dev -d
    # Create pane horizontally, $HOME directory, 50% width of current pane
    tmux rename-window -t dev BASE
    # tmux split-window -h -c $HOME -p 50 vim
    # tmux select-window -t dev:1
    # tmux select-pane -t:.1
    tmux attach -t dev
  fi
fi

#test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
eval $(/usr/libexec/path_helper -s)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kacz/Downloads/google-cloud-sdk/path.bash.inc' ]; 
  then source '/Users/kacz/Downloads/google-cloud-sdk/path.bash.inc'; 
fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kacz/Downloads/google-cloud-sdk/completion.bash.inc' ]; 
  then source '/Users/kacz/Downloads/google-cloud-sdk/completion.bash.inc'; 
fi
