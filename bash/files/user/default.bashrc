#!/usr/bin/env bash

# variables
BACKUP_DIR="$HOME/var/backup"
export BACKUP_DIR

# replace ls in macos
if is_macos; then
	MACOS_LS="$HOME/bin/macos-ls -F --color=auto --group-directories-first"
	export MACOS_LS
fi

# fzf 
if command_exists fzf; then
	eval "$(fzf --bash)"
fi

# thefuck
if command_exists thefuck; then
	eval "$(thefuck --alias)"
fi

