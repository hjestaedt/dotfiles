#!/usr/bin/env bash


if command -v gh >/dev/null 2>&1; then
    
    # github cli aliases

    alias ghprdf='gh pr diff'
    alias ghprls='gh pr list'
    alias ghprvw='gh pr view'
    alias ghrpcl='gh repo clone'
    alias ghrpls='gh repo list'
    alias ghrpvw='gh repo view'

    # github cli functions
    # todo: add functions
fi
