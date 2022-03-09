
# clear the pipes (revert to defaults)
emulate -LR zsh

source ~/.git-prompt.sh
setopt PROMPT_SUBST

eval $(/opt/homebrew/bin/brew shellenv)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#tab completion
setopt GLOB_COMPLETE
# type in a dir name and enter or ..
setopt AUTO_CD

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# timestamp in unix epoch time and elapsed time of the command
setopt EXTENDED_HISTORY
SAVEHIST=5000
HISTSIZE=2000
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY

alias c="clear"
alias sz="exec zsh"
alias grep="grep --color=auto"
alias path='echo -e ${PATH//:/\\n}'
alias funcs="functions"
alias fnames="funcs + | fgrep -v iterm"
alias shit="emulate -LR zsh"
alias pip=pip3

alias de="cd ~/Developer"

# shamelessly stolen from tyler-keith-thompson
alias ls="exa"
alias l="ls -albhF --icons --git --no-permissions --color=always"
alias xcopen='xcopen -d'
alias cat='bat --paging=never'


function co-authors() {
  local ME="nk"
  # Set Initials here
  local -A initialsMap
  while IFS== read -r key value; do
    initialsMap[$key]=$value
  done < "${HOME}/.gitpairs"
  # Parse parameters
  local parsed=("${(@s/-/)${*}}")
  local newline=$'\n'
  # NEED TO EXIT IF NO INITIALS
  if [ ${#parsed[@]} -eq 1 ]; then
    echo "${RED}No initials found." 1>&2;
    return 1
  fi
  local initialsList=("${(@s/ /)parsed[-1]}")
  initialsList=(${(L)initialsList})
  if [ ${#initialsList[@]} -eq 0 ]; then
    echo "${RED}No initials found." 1>&2;
    return 1
  fi
  initialsList=("${(@)initialsList:#$ME}")
  coAuthors=""
  [ ${#initialsList[@]} -eq 0 ] && return 0;
  coAuthors="${newline}"
  for initial in $initialsList ; do
    if [[ ! -z "${initialsMap[${(L)initial}]}" ]];
    then
      coAuthors="${coAuthors}${newline}${initialsMap[${(L)initial}]}"
    else
      echo "${RED}Unknown initials: $initial" 1>&2;
      return 1
    fi
  done;
}

function wip() {
  co-authors ${*} || return 1;
  git commit -S -m "[skip ci] `git rev-parse --abbrev-ref HEAD` - ${*}${coAuthors}"
}

function commit() {
  co-authors ${*} || return 1;
  git commit -S -m "[`git rev-parse --abbrev-ref HEAD`] - ${*}${coAuthors}"
}
# end tt

function sc() {
	cd ~/Developer/SwiftCurrent
}

function dotfiles() {
	cd ~/Developer/dotfiles
}

setopt PROMPT_SUBST
# allows git autocompletion
autoload -Uz compinit && compinit
GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_SHOWDIRTYSTATE="auto"
GIT_PS1_SHOWSTASHSTATE="auto"
GIT_PS1_SHOWUNTRACKEDFILES="auto"
GIT_PS1_SHOWCOLORHINTS="auto"
GIT_PS1_DESCRIBE_STYLE="branch"

PROMPT='%(?.%B%F{010}√.%B%F{009}?%?%f) %F{014}%1~%f%F{013}$(__git_ps1)%f %F{011}%(!.||>.|>)%f%b '
RPROMPT='%B%F{012}%*%f%b'

# Search up and down through history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

if [[ $(command -v nvm) ]]; then
    # nvm is installed
else
    echo "NVM is not installed. Installing now"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install node
    # place this after nvm initialization!
    autoload -U add-zsh-hook
    load-nvmrc() {
      local node_version="$(nvm version)"
      local nvmrc_path="$(nvm_find_nvmrc)"

      if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
          nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
          nvm use
        fi
      elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
      fi
    }
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
fi
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kaczmarn/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kaczmarn/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kaczmarn/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kaczmarn/tools/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(rbenv init - zsh)"

if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
  export SSH_AGENT_PID
fi

export GPG_TTY=$(tty)

DISABLE_AUTO_TITLE="true"

precmd() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}

