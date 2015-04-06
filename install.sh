#!/bin/sh

dotfiles=$(pwd)

# make sure all submodules are there
git submodule update --init

# [zsh]
ln -sf "$dotfiles/shell/_zshrc" "$HOME/.zshrc"
ln -sfT "$dotfiles/shell/_oh-my-zsh" "$HOME/.oh-my-zsh"

# [emacs]
ln -sfT "$dotfiles/dotEmacs" "$HOME/.emacs.d"

# [vim]
ln -sf "$dotfiles/shell/_vimrc" "$HOME/.vimrc"

# [git]
ln -sf "$dotfiles/shell/_gitconfig" "$HOME/.gitconfig"

# [tmux]
ln -sf "$dotfiles/shell/_tmux.conf" "$HOME/.tmux.conf"

echo "Finished installing dotfiles"
