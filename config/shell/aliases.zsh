alias c="clear"
alias sz="exec zsh"
alias grep="grep --color=auto"
alias path='echo -e ${PATH//:/\\n} | sort'
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
alias ls="eza"
alias l="ls -albhF --icons --git --no-permissions --color=always"
alias cat='bat --theme=Dracula'

alias xcquit="killall Xcode"

alias bbexport="defaults export com.barebones.bbedit ~/Desktop/MyBBEditPreferences.plist"
alias bbimport="defaults import com.barebones.bbedit ~/Desktop/MyBBEditPreferences.plist"
alias dotfiles="cd $DOTFILES"

alias zil="cd ~/work/ZillowMap"

alias vim=nvim
alias vi=nvim
