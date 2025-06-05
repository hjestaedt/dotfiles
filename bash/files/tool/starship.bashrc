#!/usr/bin/env bash

# starship 

if command -v starship >/dev/null 2>&1; then

    # starship aliases

    alias ssk8s="starship toggle kubernetes"
	alias ssgcp="starship toggle gcloud"

fi
