#!/usr/bin/env bash

SCRIPT=$(readlink -f -- "$0")
DOTFILESPATH=$(dirname "$SCRIPT")


git --git-dir=$DOTFILESPATH pull origin master

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
	DOTFILESPATH=$(echo "$DOTFILESPATH" | sed "s/\/c/c:/" | sed "s/\//\\\/g")
	dotfiles=( ".aliases" ".bash_profile" ".function" ".bash_prompt" ".bashrc" ".gitignore" ".gitmodules" ".gitconfig" ".inputrc" ".vimrc" ".wgetrc" ".vim" )

	for i in "${dotfiles[@]}"
	do
		local DOTFILENAME=$(echo "$DOTFILESPATH\\$i")
		cp -r "$DOTFILENAME" ~
	done
	mv ~/.vimrc ~/_vimrc
}

function linuxBootstrap() {
	rsync --exclude '.git/' \
		--exclude '.DS_Store' \
		--exclude 'bootstrap.sh' \
		--exclude 'README.md' \
		--exclude 'LICENSE-MIT.txt' \
		-avh --no-perms $DOTFILESPATH ~
	source ~/.bash_profile
}

start_bootstrap

unset start_bootstrap
unset windowsBootstrap
unset linuxBootstrap
unset SCRIPT
unset DOTFILESPATH
