#!/usr/bin/env bash

# github cli (gh)
# https://cli.github.com/manual/gh

if command -v gh >/dev/null 2>&1; then
    # github cli aliases

    alias ghrl='gh repo list'
    alias ghrv='gh repo view'
    alias ghrc='gh repo clone'

    alias ghprl='gh pr list'
    alias ghprv='gh pr view'

    # github cli functions
    # todo: add functions
fi