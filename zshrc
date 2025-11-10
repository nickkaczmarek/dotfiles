# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# homebrew only needs to have this done if we're not on intel architecture
arch=$(/usr/bin/arch)

# enable case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'



# Homebrew zsh completion dirs (Apple Silicon first, Intel fallback)
if type brew &>/dev/null; then
  HB_PREFIX="$(brew --prefix)"
  # Formula: zsh-completions
  if [[ -d "$HB_PREFIX/share/zsh-completions" ]]; then
    fpath=("$HB_PREFIX/share/zsh-completions" $fpath)
  fi
  # Many other formulae
  if [[ -d "$HB_PREFIX/share/zsh/site-functions" ]]; then
    fpath=("$HB_PREFIX/share/zsh/site-functions" $fpath)
  fi
fi

# Your personal completions first (override vendor/system)
fpath=(~/.zsh/vendor-completions ~/.zsh/completions $DOTFILES/zsh/completions $fpath)


# Load completion once
autoload -Uz compinit
compinit    # use `compinit -i` temporarily if you *still* see insecurity while fixing perms
# ---------------------------------------------------------------------------

zmodload zsh/zprof

setopt PROMPT_SUBST

# iterm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [[ -n $ITERM_SESSION_ID ]]; then
  autoload -Uz add-zsh-hook
  set_title_precmd() { print -nP '\e]0;'${PWD:t}'\a' }
  add-zsh-hook precmd set_title_precmd
fi

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

# Search up and down through history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# gpg
if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
  export SSH_AGENT_PID
fi

if [[ -o login ]]; then
  export GPG_TTY=$(tty)
  gpgconf --launch gpg-agent
fi

DISABLE_AUTO_TITLE="true"

typeset -U path # removes duplicate path variables in zsh

# mise
eval "$(mise activate zsh)"

# c/c++ packages installed by brew are not found by clang by default, the below fixes it
export C_INCLUDE_PATH=$(brew --prefix)/include
export LIBRARY_PATH=$(brew --prefix)/lib

source $DOTFILES/zgai.sh

# Load my aliases and functions
source $DOTFILES/zsh/aliases.zsh
source $DOTFILES/zsh/functions.zsh

# Autoload any functions defined as one function per file
fpath=($DOTFILES/zsh/zshfunctions $fpath)
autoload -Uz $DOTFILES/zsh/zshfunctions/*(:t)


# work thing to make builds faster
TUIST_WHOLE_MODULE_OPTIMIZATION=true
