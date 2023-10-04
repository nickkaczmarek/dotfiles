# clear the pipes (revert to defaults)
emulate -LR zsh

source ~/.git-prompt.sh
setopt PROMPT_SUBST

# homebrew only needs to have this done if we're not on intel architecture
arch=$(/usr/bin/arch)

autoload -Uz compinit && compinit

# enable case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

if [[ "$arch" -eq "arm64" ]]; then
    if [[ $(command -v brew) ]]; then
    else
        eval $(/opt/homebrew/bin/brew shellenv)
    fi
fi

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
alias path='echo -e ${PATH//:/\\n} | sort'
alias mypath='echo -e ${MYPATH//:/\\n} | sort'
alias funcs="functions"
alias fnames="funcs + | fgrep -v iterm"
alias shit="emulate -LR zsh"
alias pip=pip3
alias kick-ssh-agent="killall ssh-agent; eval `ssh-agent`"

alias de="cd ~/Developer"
alias dec="cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Developer"
alias work="cd ~/work"
alias bbdot="bbedit $DOTFILES"

# shamelessly stolen from tyler-keith-thompson
alias ls="exa"
alias l="ls -albhF --icons --git --no-permissions --color=always"
alias cat='bat --theme=Dracula'

alias xcquit="killall Xcode"

alias bbexport="defaults export com.barebones.bbedit ~/Desktop/MyBBEditPreferences.plist"
alias bbimport="defaults import com.barebones.bbedit ~/Desktop/MyBBEditPreferences.plist"
alias dotfiles="cd $DOTFILES"

alias zil="cd ~/work/ZillowMap"

function xcopen() {
	local xcode_version="$(xcode-select -p | rg '(.+Xcode.+\.app|.+Xcode\.app)' -or '$1')"
	while test $# -gt 0
	do
		case "$1" in
			(-h | --help) echo "xcopen - open Xcode"
				echo " "
				echo "xcopen [options] [directory]"
				echo " "
				echo "options:"
				echo "-h, --help        show brief help"
				echo "--beta            open latest Xcode beta"
				echo " "
				echo "directory:"
				echo "Opens in current directory or you can supply one"
				return 0 ;;
			(--beta) xcode_version="/Applications/$(ls -a /Applications | rg Xcode.+Beta | tail -1)"
				shift
				break ;;
			(*) break ;;
		esac
	done
	open -a $xcode_version ${1:-"."} -F
}

function co-authors() {
  local ME=`git config --global user.initials`
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
  git commit -S \
  -m "${*}" \
  -m "[skip ci] [`basename $(git symbolic-ref -q --short HEAD)`]" \
  -m "${coAuthors}"
}

function commit() {
  co-authors ${*} || return 1;
  git commit -S \
  -m "${*}" \
  -m "[`basename $(git symbolic-ref -q --short HEAD)`]" \
  -m "${coAuthors}"
}
# end tt

function startdemo() {
osascript <<END
tell application "System Events"
	set autohide menu bar of dock preferences to true
	set dockhidestate to autohide of dock preferences
	tell dock preferences to set autohide to true
	do shell script "defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
end tell
END
}

function enddemo() {
osascript <<END
tell application "System Events"
	set autohide menu bar of dock preferences to false
	set dockhidestate to autohide of dock preferences
	tell dock preferences to set autohide to false
	do shell script "defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
end tell
END
}



if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  ## asdf
	source /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

setopt PROMPT_SUBST
# allows git autocompletion
# autoload -Uz compinit && compinit
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

if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
  export SSH_AGENT_PID
fi

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

DISABLE_AUTO_TITLE="true"

if [ $ITERM_SESSION_ID ]; then
precmd() {
  echo -ne "\033]0;${PWD##*/}\007"
}
fi

. /opt/homebrew/opt/asdf/libexec/asdf.sh

typeset -U PATH # removes duplicate path variables in zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $HOME/.asdf/installs/terraform/1.3.7/bin/terraform terraform

# autoload zsh functions from zshfunctions folder
typeset -U fpath
my_functions=$DOTFILES/zshfunctions
if [[ -z ${fpath[(r)$my_functions]} ]] ; then
    fpath=($my_functions $fpath)
    autoload -Uz ${my_functions}/*(:t)
fi
