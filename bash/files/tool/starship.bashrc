#!/usr/bin/env bash

if command -v starship >/dev/null 2>&1; then

    # starship aliases

    alias ssp='starship'
    alias ssptogcl='starship toggle gcloud'
    alias ssptokb='starship toggle kubernetes'
	alias ssptotf='starship toggle terraform'
	alias ssptodck='starship toggle docker_context'

	# starship functions

	ssptog() {
		starship toggle git_branch
		starship toggle git_commit
		starship toggle git_state
		starship toggle git_status
	}

fi
