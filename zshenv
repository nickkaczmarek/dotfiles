typeset -U path                     # unique-ify $path entries
export DOTFILES="$HOME/Developer/dotfiles"
export DOTBIN="$DOTFILES/bin"
export DOTGIT="$DOTFILES/git"
export GEM_HOME="$HOME/.gem"
export DOTLOCAL="$HOME/.local/bin"
export HOMEBREW="/opt/homebrew/bin"

export DERIVED_DATA=$HOME/Library/Developer/Xcode/DerivedData
# Safer quoting for the iCloud path (avoid backslashes in env values)
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

export EDITOR_GIT="/Applications/Fork.app"

export CLICOLOR=1
export LSCOLORS=ExfxcxdxBxegedabagacad
export EXA_COLORS="uu=2;33:da=0;37"

# Build PATH using the array
path=(
    $GEM_HOME/bin
    $DOTBIN
    $DOTLOCAL
    $HOMEBREW
    $path
)
export PATH   # reflect array -> string
