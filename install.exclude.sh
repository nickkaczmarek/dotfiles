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
		   	for file in $( ls -RA $BASEDIR/.zsh | grep -vE '\.exclude*|\.git$|\.gitignore|\.DS_Store|.*.md|zshfunctions' ) ; do
				ln -sfnv "$BASEDIR/.zsh/$file" "$HOME"
			done
		   	;;
		*/bash)
		   	# assume Bash
		   	for file in $( ls -A $BASEDIR | grep -vE '\.exclude*|\.git$|\.gitignore|\.DS_Store|.*.md' ) ; do
				ln -sfnv "$BASEDIR/.bash/$file" "$HOME"
			done
		   	;;
		*)
		   	# assume something else
			echo "$SHELL not supported"
		esac
		
		for file in $( ls -A $BASEDIR | grep -vE '\.exclude*|\.git$|\.gitignore|\.DS_Store|.*.md|\.zsh' ) ; do
			ln -sfnv "$BASEDIR/$file" "$HOME"
		done
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
			echo "Installing useful stuff using brew. This may take a while..."
			sh brew.exclude.sh
		else
			echo "Brew installation cancelled by user"
		fi
	else
		echo "Skipping installations using Homebrew because MacOS was not detected..."
	fi
}

link
install_tools




