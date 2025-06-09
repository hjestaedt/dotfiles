#!/usr/bin/env bash

#
# variables
#

BACKUP_DIR="$HOME/var/backup"
export BACKUP_DIR


#
# tools
#

if command_exists fzf; then
	eval "$(fzf --bash)"
fi

if command_exists thefuck; then
	eval "$(thefuck --alias)"
fi

#
# aliases
#

if command_exists bat; then
	alias cat='bat -p'
fi

#
# misc
#

# replace ls (macos)
if is_macos; then
	MACOS_LS="$HOME/bin/macos-ls -F --color=auto --group-directories-first"
	export MACOS_LS
fi
