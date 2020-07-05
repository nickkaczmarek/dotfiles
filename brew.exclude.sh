#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Install homebrew if it is not installed
which brew 1>&/dev/null
if [ ! "$?" -eq 0 ] ; then
	echo "Homebrew not installed. Attempting to install Homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	if [ ! "$?" -eq 0 ] ; then
		echo "Something went wrong. Exiting..." && exit 1
	fi
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# ---------------------------------------------
# Programming Languages and Frameworks
# ---------------------------------------------

# Python 3
 brew install python

# Golang
brew install go

# ---------------------------------------------
# Useful tools
# ---------------------------------------------

# Make requests with awesome response formatting
# brew install httpie

# Show directory structure with excellent formatting
brew install tree

# tmux :'D 
brew install tmux

# gdb
# brew install gdb

brew cask install qlmarkdown qlstephen qlvideo quicklook-json suspicious-package

xattr -d -r com.apple.quarantine ~/Library/QuickLook

# Remove outdated versions from the cellar
brew cleanup
