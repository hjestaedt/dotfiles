#!/usr/bin/env bash

# MacOS specific configuration
if is_macos; then

	# disable bash deprecation warning
	BASH_SILENCE_DEPRECATION_WARNING=1
	export BASH_SILENCE_DEPRECATION_WARNING

	# initialize homebrew
	if command_exists /opt/homebrew/bin/brew; then # check with full path!
	 	eval "$(/opt/homebrew/bin/brew shellenv)"
		for d in "$HOMEBREW_PREFIX"/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done
	    for d in "$HOMEBREW_PREFIX"/opt/*/libexec/gnuman; do export MANPATH=$d:$MANPATH; done
		export PATH MANPATH
	fi
fi
