#!/usr/bin/env bash

# git

if command -v git >/dev/null 2>&1; then

    # git aliases
    alias g='git'
    alias ga='git add'
    alias ga.='git add .'
    alias gaa='git add --all'
    alias gb='git branch'
    alias gbr='git branch --remote'
    alias gba='git branch -a'
    alias gbd='git branch -d'
    alias gbD='git branch -D'
    alias gbm='git branch -m'
    alias gc='git commit'
    alias gca='git commit --amend'
    alias gcm='git commit -m'
    alias grs='git restore'
    alias grs.='git restore .'
    alias grss='git restore --staged'
    alias grss.='git restore --staged .'
    alias gd='git diff'
    alias gds='git diff --staged'
    alias gf='git fetch'
    alias gfp='git fetch --prune'
    alias gl='git log'
    alias glg='git log --graph --oneline --decorate --all'
    alias gls='git log --stat'
    alias gp='git push'
    alias gpf='git push --force'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias grb='git rebase'
    alias grbi='git rebase -i'
    alias grba='git rebase --abort'
    alias gr='git reset'
    alias grh='git reset --hard'
    alias grma='git remote add'
    alias grmd='git remote rm'
    alias grmv='git remote -v'
    alias gs='git status'
    alias gsw='git switch'
    alias gsw-='git switch -'
    alias gswrb='git switch main && git pull && git switch - && git rebase main'

    # git functions

fi