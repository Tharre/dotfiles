#!/bin/sh

root=$(pwd)

# make sure all submodules are there
git submodule update --init

# [zsh]
ln -sf "$root/shell/_zshrc" "$HOME/.zshrc"
ln -sfT "$root/shell/_oh-my-zsh" "$HOME/.oh-my-zsh"

# [emacs]
ln -sfT "$root/dotEmacs" "$HOME/.emacs.d"

# [vim]
ln -sf "$root/shell/_vimrc" "$HOME/.vimrc"

# [git]
ln -sf "$root/shell/_gitconfig" "$HOME/.gitconfig"

# [tmux]
ln -sf "$root/shell/_tmux.conf" "$HOME/.tmux.conf"

echo "Finished installing dotfiles"
