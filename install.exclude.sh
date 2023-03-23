#!/bin/sh

link () {
    echo "This utility will symlink the files in this repo to the home directory"
    echo "Proceed? (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        BASEDIR=$(dirname "$0")
        case $SHELL in
        */zsh)
            ln -sfnv "$BASEDIR/zshrc" "$HOME/.zshrc"
            ln -sfnv "$BASEDIR/zlogin" "$HOME/.zlogin"
            ln -sfnv "$BASEDIR/zlogout" "$HOME/.zlogout"
            ln -sfnv "$BASEDIR/zshenv" "$HOME/.zshenv"
            ln -sfnv "$BASEDIR/git-prompt" "$HOME/.git-prompt.sh"
            ln -sfnv "$BASEDIR/gitconfig" "$HOME/.gitconfig"
            ln -sfnv "$BASEDIR/gitconfig-personal" "$HOME/.gitconfig-personal"
            ln -sfnv "$BASEDIR/gitconfig-work" "$HOME/work/.gitconfig-work"
            ln -sfnv "$BASEDIR/vimrc" "$HOME/.vimrc"
            ln -sfnv "$BASEDIR/.macos" "$HOME/.macos"
            ln -sfnv "$BASEDIR/Brewfile" "$HOME/Brewfile"
            ln -sfnv "$BASEDIR/gitpairs" "$HOME/.gitpairs"
            ;;
        esac
        echo "Symlinking complete"
    else
        echo "Symlinking cancelled by user"
        return 1
    fi
}

install_tools () {
    if [ $( echo "$OSTYPE" | grep 'darwin' ) ] ; then
        echo "This utility will install useful utilities using Homebrew"
        echo "Proceed? (y/n)"
        read resp
        if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
            echo "Setting macOS sane defaults"
            source ~/.macos

            osascript -e 'tell application "iTerm2" to activate'

            sh ~/Developer/dotfiles/check-arm-and-install-rosetta2.sh
            echo "Checking if homebrew is installed"
            if [[ $(command -v brew) ]]; then
                echo "Homebrew is installed"
            else
                echo "Installing Homebrew"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            echo "Installing from Brewfile"
            # https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f
            brew bundle install
        else
            echo "Brew installation cancelled by user"
        fi
    else
        echo "Skipping installations using Homebrew because MacOS was not detected..."
    fi
}

link
install_tools
