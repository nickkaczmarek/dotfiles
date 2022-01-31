
# clear the pipes (revert to defaults)
emulate -LR zsh

source ~/.git-prompt.sh
setopt PROMPT_SUBST
# PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#tab completion
setopt GLOB_COMPLETE
# type in a dir name and enter or ..
setopt AUTO_CD

###########################################################
# HISTORY
###########################################################

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

###########################################################
# TEXT CORRECTION
###########################################################

# setopt CORRECT
# setopt CORRECT_ALL

###########################################################
# ALIASES
###########################################################

alias ls="ls -G"
alias la="ls -aF"
alias ll="ls -halF"
alias c="clear"
alias sb="source ~/.zshrc"
alias grep="grep --color=auto"
alias path='echo -e ${PATH//:/\\n}'
alias funcs="functions"
alias fnames="funcs + | fgrep -v iterm"
alias shit="emulate -LR zsh"
alias bbedit="open -a /Applications/BBEdit.app"
alias pip=pip3

# alias git='nocorrect git '

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if [ ! $(uname -s) = 'Darwin' ]; then
	if grep -q Microsoft /proc/version; then
		# Ubuntu on Windows using the Linux subsystem
		alias open='explorer.exe';
	else
		alias open='xdg-open';
	fi
fi

###########################################################
# FUNCTIONS
###########################################################

tmuxcolours() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m"
  done
}

# Create a new directory and enter it
mcd () {
    mkdir -p $1
    cd $1
}

ostest() {
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
  esac
  echo ${machine}
}

tputcolors() {
  for i in {0..255};
    do tput setab $i;
      echo -n "$i    ";
    done;
    tput setab 0;
    echo;
}

anothercolortest() {
  ( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;for i in {0..255};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done; )
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
	);

	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Use Git’s colored diff when available
# hash git &>/dev/null;
# if [ $? -eq 0 ]; then
# 	function diff() {
# 		git diff --no-index --color-words "$@";
# 	}
# fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

function p() {
	cd ~/dev/LCE/Caesar-Vision-Next-Gen
}

function pe() {
	cd ~/dev/LCE/Caesar-Vision-Next-Gen/ElectronUI
}

###########################################################
# PROMPT
###########################################################

setopt PROMPT_SUBST
# allows git autocompletion
autoload -Uz compinit && compinit
GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_SHOWDIRTYSTATE="auto"
GIT_PS1_SHOWSTASHSTATE="auto"
GIT_PS1_SHOWUNTRACKEDFILES="auto"
GIT_PS1_SHOWCOLORHINTS="auto"
GIT_PS1_DESCRIBE_STYLE="branch"

# precmd () { __git_ps1 "%n" "%~$ " "|%s" }
PROMPT='%(?.%B%F{010}√.%B%F{009}?%?%f) %F{014}%1~%f%F{013}$(__git_ps1)%f %F{011}%(!.||>.|>)%f%b '
# PROMPT='%(?.%B%F{010}√.%B%F{009}?%?%f) %F{014}%1~%f %F{011}%(!.||>.|>)%f%b '
RPROMPT='%B%F{012}%*%f%b'

# Search up and down through history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

###########################################################
# nvm
###########################################################

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
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kaczmarn/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kaczmarn/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kaczmarn/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kaczmarn/tools/google-cloud-sdk/completion.zsh.inc'; fi

###########################################################
# rbenv
###########################################################

# Load rbenv automatically by appending
# the following to ~/.zshrc:

eval "$(rbenv init - zsh)"

###########################################################
# GPG
###########################################################
if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
  export SSH_AGENT_PID
fi

export GPG_TTY=$(tty)
