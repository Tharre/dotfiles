#!/bin/sh -e

dotfiles=$(pwd)

# make sure all submodules are there
git submodule update --init --recursive

# [zsh]
ln -sf "$dotfiles/shell/_zshrc" "$HOME/.zshrc"
ln -sfT "$dotfiles/shell/_oh-my-zsh" "$HOME/.oh-my-zsh"
ln -sfT "$dotfiles/shell/themes" "$HOME/.oh-my-zsh/custom/themes"

# [vim]
ln -sf "$dotfiles/shell/_vimrc" "$HOME/.vimrc"
ln -sfT "$dotfiles/shell/_vim" "$HOME/.vim"

# [git]
ln -sf "$dotfiles/shell/_gitconfig" "$HOME/.gitconfig"

# [tmux]
ln -sf "$dotfiles/shell/_tmux.conf" "$HOME/.tmux.conf"

# [gdb]
ln -sf "$dotfiles/shell/_gdbinit" "$HOME/.gdbinit"

# [gpg]
ln -sfT "$dotfiles/shell/_gnupg" "$HOME/.gnupg"

# [emacs]
ln -sfT "$dotfiles/shell/_emacs.d" "$HOME/.emacs.d"

# [user dirs]
ln -sf "$dotfiles/config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"

if [ "$1" = "arch" ]; then
	echo "Performing full installation."

	# [arch linux]
	ln -sf "$dotfiles/shell/_makepkg.conf" "$HOME/.makepkg.conf"

	# [email]
	ln -sfT "$dotfiles/email/_mutt" "$HOME/.mutt"
	ln -sf "$dotfiles/email/_offlineimaprc" "$HOME/.offlineimaprc"
	ln -sf "$dotfiles/email/_msmtprc" "$HOME/.msmtprc"
	mkdir -p ~/.mail
fi

echo "Finished installing dotfiles"
