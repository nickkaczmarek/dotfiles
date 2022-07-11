###########################################################
# PATH
###########################################################

echo "running zshenv"
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH
export PATH=~/.mint/bin:$PATH
export CLICOLOR=1
export LSCOLORS=ExfxcxdxBxegedabagacad
export EXA_COLORS="uu=2;33:da=0;37"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
