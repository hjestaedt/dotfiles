#!/usr/bin/env bash

if command -v git >/dev/null 2>&1; then

    # git aliases

	# git 
	# https://git-scm.com/docs/git
    alias g='git'
	
	# git status
	# https://git-scm.com/docs/git-status
    alias gst='git status --show-stash'
    alias gsts='git status -sb'

	# git add
	# https://git-scm.com/docs/git-add
    alias gad='git add'
    alias gad.='git add .'
    alias gada='git add --all'

	# git commit
	# https://git-scm.com/docs/git-commit
    alias gcm='git commit'
    alias gcmm='git commit -m'
    alias gcma='git commit -a'
	alias gcmo='git commit -o'
    alias gcmam='git commit -am'
	alias gcmom='git commit -om'
    alias gcmamn='git commit --amend'
	
	# git log
	# https://git-scm.com/docs/git-log
    alias glg='git log'
	alias glgo='git log --oneline'
	alias glga='git log --all'
	alias glgg='git log --graph'
    alias glgs='git log --stat'
    alias glgoa='git log --oneline --all'
    alias glgog='git log --oneline --graph'
	alias glgos='git log --oneline --stat'

	# git show
	# https://git-scm.com/docs/git-show
	alias gsh='git show'
	alias gsho='git show --oneline'

	# git show piped to delta
	# https://github.com/dandavison/delta
	if command -v delta >/dev/null 2>&1; then
		alias gshd='git show --oneline | delta'
		alias gshds='git show --oneline | delta -s'
	fi

	# 

    alias gbr='git branch'
    alias gbra='git branch -a'
    alias gbrd='git branch -d'
    alias gbrD='git branch -D'
    alias gbrm='git branch -m'
    alias gbrr='git branch --remote'
    alias gcfg='git config'
    alias gcfgg='git config --global'
    alias gcfgl='git config --local'
    alias gcl='git clone'
    alias gco='git checkout'
    alias gcob='git checkout -b'
    alias gdf='git diff'
    alias gdfs='git diff --staged'
    alias gdft='git difftool'
    alias gdfts='git difftool --staged'
    alias gft='git fetch'
    alias gftp='git fetch --prune'
    alias gini='git init'
    alias gmg='git merge'
    alias gmv='git mv'
    alias gno='git notes'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias gpsh='git push'
    alias gpshf='git push --force'
    alias grb='git rebase'
    alias grba='git rebase --abort'
    alias grbi='git rebase -i'
    alias grema='git remote add'
    alias gremr='git remote rm'
    alias gremv='git remote -v'
    alias gres='git restore'
    alias gres.='git restore .'
    alias gress='git restore --staged'
    alias gress.='git restore --staged .'
    alias grfl='git reflog'
    alias grm='git rm'
    alias grmc='git rm --cached'
    alias grst='git reset'
    alias grsthd='git reset --hard'
    alias grstmx='git reset --mixed'
    alias grstsf='git reset --soft'
    alias gsth='git stash'
    alias gstha='git stash apply'
    alias gsthc='git stash clear'
    alias gsthd='git stash drop'
    alias gsthl='git stash list'
    alias gsthp='git stash pop'
    alias gsw='git switch'
    alias gswc='git switch -c'
    alias gsw-='git switch -'

    # git functions

    # description:
    #   rebase current branch onto another branch after updating it
    # arguments:
    #   branch_name - name of the branch to rebase onto
    # usage:
    #   grbbr <branch_name>
    #   e.g.: grbbr main, grbbr develop
    grbbr() {
        [ -n "$1" ] || { echo "branch name argument required" >&2; return 1; }
        git switch "$1" && \
        git pull --rebase && \
        git switch - && \
        git rebase "$1"
    }
fi
