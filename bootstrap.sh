#!/usr/bin/env bash

function start_bootstrap() {
	if [ "$OS" == "" ]; then
		linuxBootstrap
	elif [ "$OS" = "Windows_NT" ]; then
		windowsBootstrap
	else
		echo "ERROR: Unknown OS: $OS"
	fi
}

function windowsBootstrap() {
	local DOTFILESPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	DOTFILESPATH=$(echo "$DOTFILESPATH" | sed "s/\/c/C:/" | sed "s/\//\\\/g")
	echo "$DOTFILESPATH"
	git --git-dir=$DOTFILESPATH\\.git pull origin master

	dotfiles=( ".aliases" ".bash_profile" ".function" ".bash_prompt" ".bashrc" ".gitignore" ".gitmodules" ".gitconfig" ".inputrc" ".vimrc" ".wgetrc" ".vim" )

	for i in "${dotfiles[@]}"
	do
		local file_name=$(echo "$DOTFILESPATH\\$i" | sed "s/'\\'/'\'/g")
		echo "$file_name"
		# cp -r "$file_name" ~
	done
	mv ~\.vimrc ~\_vimrc
}

function linuxBootstrap() {
	# Get bootstrap.sh directory path
	local SOURCE="${BASH_SOURCE[0]}"
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	  SOURCE="$(readlink "$SOURCE")"
	  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
	done
	DOTFILESPATH="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

	# Update
	git remote | grep origin &> /dev/null && git --git-dir=$DOTFILESPATH/.git pull origin master

	# Sync
	rsync --exclude '.git/' \
		--exclude '.DS_Store' \
		--exclude 'bootstrap.sh' \
		--exclude 'README.md' \
		--exclude 'LICENSE-MIT.txt' \
		-avh --no-perms $DOTFILESPATH/ $HOME
	source ~/.bash_profile
}

start_bootstrap

unset start_bootstrap
unset windowsBootstrap
unset linuxBootstrap
