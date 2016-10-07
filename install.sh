#!/bin/sh -e

if [ "$#" -ne 1 ]; then
	# make sure all submodules are there
	git submodule update --init --recursive

	# create directories
	mkdir -p ~/bin
	mkdir -p ~/etc
	mkdir -p ~/share
	mkdir -p ~/media
	mkdir -p ~/media/games
	mkdir -p ~/media/music
	mkdir -p ~/media/pictures
	mkdir -p ~/media/videos
	mkdir -p ~/var
	mkdir -p ~/var/cache
	mkdir -p ~/var/downloads
	mkdir -p ~/var/log
	mkdir -p ~/var/run
	mkdir -p ~/var/tmp
	mkdir -p ~/var/vim
	mkdir -p ~/var/VMs
	mkdir -p ~/.mail

	find . -maxdepth 1 ! -path . ! -name .git ! -name .gitmodules \
		! -name .gitignore ! -name .updated -name '.*' -exec "$0" {} \;

	echo "Finished installing dotfiles"
else
	canonical=$(echo $1 | sed "s|^\./||")
	target="$HOME/$canonical"
	origin="$(pwd)/$canonical"

	if [ ! -e "$target" ] || [ -L "$target" ]; then
		# target either doesn't exist or is a symbolic link and can thus be
		# safely replaced
		ln -sfT "$origin" "$target"
	elif [ -d "$target" ]; then
		# target is not a symbolic link, but a directory, thus we link
		# everything into that directory instead

		find "$canonical" -maxdepth 1 -mindepth 1 ! -name .gitignore \
			-exec "$0" {} \;
	else
		echo "Target file '$target' is not a symlink but exists, skipping"
	fi
fi
