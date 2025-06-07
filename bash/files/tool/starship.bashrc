#!/usr/bin/env bash

if command -v starship >/dev/null 2>&1; then

    # starship aliases

    alias ssp="starship"
    alias ssptogcp="starship toggle gcloud"
    alias ssptok8s="starship toggle kubernetes"

	# starship functions

	ssptogit() {
		starship toggle git_branch
		starship toggle git_commit
		starship toggle git_state
		starship toggle git_status
	}

fi
