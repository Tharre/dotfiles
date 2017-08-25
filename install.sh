#!/bin/sh -e

# Note that filenames MUST NOT CONTAIN NEWLINES!

symlink_file() {
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
			-print | while IFS= read -r file
		do
			symlink_file "$file"
		done
	else
		echo "Target file '$target' exists, but is not a symlink. Skipping."
	fi
}

# make sure all submodules are there
git submodule update --init --recursive

# ensure mail directory exists
mkdir -p ~/.mail/tharre3@gmail.com

find . -maxdepth 1 ! -path . ! -name .git ! -name .gitmodules \
	! -name .gitignore ! -name .updated -name '.*' -print | while IFS= read -r file
do
	symlink_file "$file"
done

# remove broken symlinks
find -L "$HOME" -maxdepth 1 -type l -delete
