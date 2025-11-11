#!/bin/bash

# Dotfiles Manifest - Single Source of Truth
# This file defines all symlinks that should be created during installation
# Both the installer and shell-doctor use this manifest

# Format: "source:target[:type]"
#   source - relative to DOTFILES directory
#   target - absolute path where symlink should be created
#   type   - optional, "dir" for directory symlinks

declare -a DOTFILES_SYMLINKS=(
    # Shell configs
    "config/shell/zshrc:$HOME/.zshrc"
    "config/shell/zshenv:$HOME/.zshenv"
    "config/shell/.p10k.zsh:$HOME/.p10k.zsh"
    "config/shell/.macos:$HOME/.macos"
    "config/shell/.mise.toml:$HOME/.config/mise/config.toml"
    
    # Git configs
    "config/git/gitconfig:$HOME/.gitconfig"
    "config/git/gitconfig-personal:$HOME/.gitconfig-personal"
    "config/git/gitconfig-work:$HOME/.gitconfig-work"
    "config/git/gitconfig-personal-work:$HOME/.gitconfig-personal-work"
    "config/git/gitpairs:$HOME/.gitpairs"
    "config/git/.gitmessage:$HOME/.gitmessage"
    
    # Vim
    "config/vim/gvimrc:$HOME/.gvimrc"
    
    # Neovim (special - directory symlink)
    "config/nvim:$HOME/.config/nvim:dir"
    
    # Brew
    "brew/Brewfile:$HOME/Brewfile"
)


