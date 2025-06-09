#!/usr/bin/env bash


if command -v gh >/dev/null 2>&1; then
    
    # github cli aliases

    alias ghrpcl='gh repo clone'
    alias ghrpls='gh repo list'
    alias ghrpvw='gh repo view'
	alias ghrpssh='gh repo view --json sshUrl -q .sshUrl'

    alias ghprdf='gh pr diff'
    alias ghprls='gh pr list'
    alias ghprvw='gh pr view'

    # github cli functions
	# TODO	
fi
