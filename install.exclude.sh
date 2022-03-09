#!/bin/sh

# TODO : Delete symlinks to deleted files
# Is this where rsync shines?
# TODO - add support for -f and --force
link () {
	echo "This utility will symlink the files in this repo to the home directory"
	echo "Proceed? (y/n)"
	read resp
	# TODO - regex here?
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		BASEDIR=$(dirname "$0")
		case $SHELL in
		*/zsh)
		   	# assume Zsh
		   	ln -sfnv "$BASEDIR/zshrc" "$HOME/.zshrc"
		   	ln -sfnv "$BASEDIR/zlogin" "$HOME/.zlogin"
		   	ln -sfnv "$BASEDIR/zlogout" "$HOME/.zlogout"
		   	ln -sfnv "$BASEDIR/zshenv" "$HOME/.zshenv"
		   	ln -sfnv "$BASEDIR/git-prompt" "$HOME/.git-prompt.sh"
		   	ln -sfnv "$BASEDIR/gitconfig" "$HOME/.gitconfig"
		   	ln -sfnv "$BASEDIR/vimrc" "$HOME/.vimrc"
		   	ln -sfnv "$BASEDIR/.macos" "$HOME/.macos"
		   	ln -sfnv "$BASEDIR/Brewfile" "$HOME/Brewfile"
		   	;;
		# */bash)
# 		   	# assume Bash
# 		   	for file in $( ls -A $BASEDIR | grep -vE '\.exclude*|\.git$|\.gitignore|\.DS_Store|.*.md' ) ; do
# 				ln -sfnv "$BASEDIR/.bash/$file" "$HOME"
# 			done
# 		   	;;
# 		*)
# 		   	# assume something else
# 			echo "$SHELL not supported"
		esac
#
# 		for file in $( ls -A $BASEDIR | grep -vE '\.exclude*|\.git$|\.gitignore|\.DS_Store|.*.md|\.zsh' ) ; do
# 			ln -sfnv "$BASEDIR/$file" "$HOME"
# 		done
		# TODO: source files here?
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
		# TODO - regex here?
		if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
            echo "Setting macOS sane defaults"
		   	# source ~/.macos

		   	osascript -e 'tell application "iTerm2" to activate'

            sh ~/Developer/dotfiles/check-arm-and-install-rosetta2.sh
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
