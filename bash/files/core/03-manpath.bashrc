#!/usr/bin/env bash

if [ -z "$MANPATH" ]; then
	MANPATH="$HOME/.local/share/man"
else
	MANPATH="$HOME/.local/share/man:$MANPATH"
fi
export MANPATH
