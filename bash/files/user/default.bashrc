#!/usr/bin/env bash

# variables
BACKUP_DIR="$HOME/var/backup"
export BACKUP_DIR

# fzf 
if command_exists fzf; then
	eval "$(fzf --bash)"
fi
