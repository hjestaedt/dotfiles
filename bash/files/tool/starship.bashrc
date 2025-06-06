#!/usr/bin/env bash

# starship 

if command -v starship >/dev/null 2>&1; then

    # starship aliases

    alias ssk8s="starship toggle kubernetes"
	alias ssgcp="starship toggle gcloud"

	# starship functions

    # toggle starship git modules
    # usage:
    #   ssgit
	ssgit() {
		starship toggle git_branch
		starship toggle git_commit
		starship toggle git_state
		starship toggle git_status
	}

fi
