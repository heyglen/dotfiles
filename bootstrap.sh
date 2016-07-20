#!/usr/bin/env bash

SCRIPT=$(readlink -f -- $0")
DOTFILESPATH=$(dirname "$SCRIPT" | sed "s/\/c/c:/" | sed "s/\//\\\/g")

git pull origin master;

function bootstrap() {
	if [ -z "$OS" ]; then
		linuxBootstrap;
	else
		if [ "$OS" = "Windows_NT" ]; then
			windowsBootstrap;
		else
			echo "ERROR: Unknown OS: $OS"
		fi;
	fi;
}

function windowsBootstrap() {
	dotfiles=( ".aliases" ".bash_profile" ".function" ".bash_prompt" ".bashrc" ".gitignore" ".gitmodules" ".gitconfig" ".inputrc" ".vimrc" ".wgetrc" ".vim")

	for i in "${dotfiles[@]}"
	do
		DOTFILENAME=$(echo "$DOTFILESPATH\\$i")
		cp -r "$DOTFILENAME" ~
	done
	unset DOTFILENAME
	mv ~/.vimrc ~/_vimrc
}

function linuxBootstrap() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	bootstrap;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		bootstrap;
	fi;
fi;

unset bootstrap;
unset windowsBootstrap;
unset linuxBootstrap;
unset SCRIPT;
unset DOTFILESPATH;
