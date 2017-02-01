#!/bin/sh -e

if [ "$#" -ne 1 ]; then
	# make sure all submodules are there
	git submodule update --init --recursive

	# ensure mail directory exists
	mkdir -p ~/.mail

	find . -maxdepth 1 ! -path . ! -name .git ! -name .gitmodules \
		! -name .gitignore ! -name .updated -name '.*' -exec "$0" {} \;
else
	canonical=$(echo $1 | sed "s|^\./||")
	target="$HOME/$canonical"
	origin="$(pwd)/$canonical"

	if [ ! -e "$target" ] || [ -L "$target" ]; then
		# target either doesn't exist or is a symbolic link and can thus be
		# safely replaced
		ln -sfn "$origin" "$target"
	elif [ -d "$target" ]; then
		# target is not a symbolic link, but a directory, thus we link
		# everything into that directory instead

		find "$canonical" -maxdepth 1 -mindepth 1 ! -name .gitignore \
			-exec "$0" {} \;
	else
		echo "Target file '$target' is not a symlink but exists, skipping"
	fi
fi
