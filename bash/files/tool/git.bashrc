#!/usr/bin/env bash

if command_exists git; then

    # fzf
    # https://github.com/junegunn/fzf
    if command_exists fzf; then
        FZF=1
    fi

    # delta
    # https://github.com/dandavison/delta
    if command_exists delta; then
        DELTA=1
    fi

    # git aliases

    # git
    # https://git-scm.com/docs/git
    alias g='git'

    # git status
    # https://git-scm.com/docs/git-status
    alias gsts='git status --show-stash'
    alias gstss='git status -sb'

    # git add
    # https://git-scm.com/docs/git-add
    alias gad='git add'
    alias gad.='git add .'
    alias gada='git add --all'

	# git clean
	# https://git-scm.com/docs/git-clean
	alias gclr='git clean'
	alias gclrf='git clean -f'
	alias gclrfd='git clean -fd'
	alias gclrfd='git clean -fd'

	# git rm
	# https://git-scm.com/docs/git-rm
    alias grm='git rm'
	alias grmf='git rm -f'
	alias grmr='git rm -r'
	alias grmrf='git rm -rf'
    alias grmc='git rm --cached'
    alias grmrc='git rm -r --cached'
	
	# git diff
	#
    # https://git-scm.com/docs/git-diff
    alias gdf='git diff'
    alias gdfs='git diff --staged'
    alias gdft='git difftool'
    alias gdfts='git difftool --staged'
    if ((DELTA)); then
    	alias gdfd='git diff | delta'
    	alias gdfds='git diff | delta -s'
	    alias gdfsd='git diff --staged | delta'
		alias gdfsds='git diff --staged | delta -s'
	fi

    # git commit
    # https://git-scm.com/docs/git-commit
    alias gcm='git commit'
    alias gcmm='git commit -m'
    alias gcma='git commit -a'
    alias gcmo='git commit -o'
    alias gcmma='git commit -am'    
    alias gcmmo='git commit -om'
	alias gcmne='git commit --no-edit'
    alias gcmamn='git commit --amend'
    alias gcmamnne='git commit --amend --no-edit'

    # git log
    # https://git-scm.com/docs/git-log
    alias glg='git log --oneline'
    alias glga='git log --oneline --all'
    alias glgg='git log --oneline --graph'
    alias glgs='git log --oneline --stat'

    alias glgf='git log'
    alias glgfa='git log --all'
    alias glgfg='git log --graph'
    alias glgfs='git log --stat'

    # git show
    # https://git-scm.com/docs/git-show
    alias gsh='git show'
    alias gsho='git show --oneline'
    if ((DELTA)); then
        alias gshd='git show --oneline | delta'
        alias gshds='git show --oneline | delta -s'
    fi

    # git restore
    # https://git-scm.com/docs/git-restore
    alias gres='git restore'
    alias gres.='git restore .'
	alias gresa='git restore :/'
    alias gress='git restore --staged'
    alias gress.='git restore --staged .'
    alias gressa='git restore --staged :/'
	
    # git reset
    # https://git-scm.com/docs/git-reset
    alias grst='git reset'
    alias grstsf='git reset --soft'
    alias grstmx='git reset --mixed'
    alias grsthd='git reset --hard'

	# git branch
	# https://git-scm.com/docs/git-branch
    alias gbr='git branch'
    alias gbra='git branch -a'
    alias gbrd='git branch -d'
    alias gbrdf='git branch -d -f'
    alias gbrm='git branch -m'
    alias gbrr='git branch -r'

    # git switch
    # https://git-scm.com/docs/git-switch
    alias gsw='git switch'
    alias gswc='git switch -c'
    alias gsw-='git switch -'

    # git merge 
    # https://git-scm.com/docs/git-merge
    alias gmg='git merge'
	alias gmgff='git merge --ff'
	alias gmgnff='git merge --no-ff'
	alias gmgnc='git merge --no-commit'
	alias gmgsq='git merge --squash'
	alias gmgsqne='git merge --squash && git commit --no-edit'
	alias gmgab='git merge --abort'

	# git tag
    # https://git-scm.com/docs/git-tag
	alias gtg='git tag'
	alias gtgl='git tag -l'
	alias gtgd='git tag -d'
	
	# git stash
    # https://git-scm.com/docs/git-stash
	alias gsth='git stash'
    alias gsthap='git stash apply'
    alias gsthclr='git stash clear'
    alias gsthdrp='git stash drop'
    alias gsthls='git stash list'
    alias gsthpp='git stash pop'

	# git pull
    # https://git-scm.com/docs/git-pull
    alias gpl='git pull'
    alias gplrb='git pull --rebase'

	# git push
    # https://git-scm.com/docs/git-push
    alias gpsh='git push'
    alias gpshf='git push --force'
    alias gpsht='git push --tags'


    alias gcfg='git config'
    alias gcfgg='git config --global'
    alias gcfgl='git config --local'
    alias gcln='git clone'
    alias gco='git checkout'
    alias gcob='git checkout -b'
	alias gft='git fetch'
    alias gftp='git fetch --prune'
    alias gini='git init'
    alias gmv='git mv'
    alias gno='git notes'
    alias grb='git rebase'
    alias grba='git rebase --abort'
    alias grbi='git rebase -i'
    alias grema='git remote add'
    alias gremr='git remote rm'
    alias gremv='git remote -v'
    alias grfl='git reflog'

    # git functions

    # grbbr - rebase current branch onto another branch after updating it
    # description:
    #   rebase current branch onto another branch after updating it
    # arguments:
    #   branch_name - name of the branch to rebase onto
    # usage:
    #   grbbr <branch_name>
    #   e.g.: grbbr main, grbbr develop
    grbbr() {
        [ -n "$1" ] || {
            echo "branch name argument required" >&2
            return 1
        }
        git switch "$1" &&
            git pull --rebase &&
            git switch - &&
            git rebase "$1"
    }

    if ((FZF)); then

    # gswfz - switch to a git branch using fzf
    # description:
    #   interactively switch to a git branch using fzf
    #   shows local branches and remote branches without local counterparts
    # arguments:
    #   none - uses fzf for interactive selection
    # usage:
    #   gswfz
    # note:
    #   automatically creates local tracking branches for remote branches
    gswfz() {
        local current_branch
        current_branch=$(git branch --show-current)

        local local_branches
        local_branches=$(git branch --format='%(refname:short)')

        local available_branches
        available_branches=$(
            {
                # show current branch last
                if [ -n "$current_branch" ]; then
                    echo "[current] $current_branch"
                fi

                # show local branches (excluding current)
                echo "$local_branches" | awk -v current="$current_branch" '{
                    if($0 != current) {
                        print "[local] " $0
                    }
                }'
                
                # show remote branches that don't have local counterparts
                comm -23 \
                    <(git branch -r | grep -v HEAD | sed 's/^[* ] *//' | sed 's/^[^\/]*\///' | sort) \
                    <(echo "$local_branches" | sort) | \
                awk '{print "[remote] " $0}'
            }
        )

        local selected_branch
        selected_branch=$(echo "$available_branches" | fzf)

        if [ -n "$selected_branch" ]; then
            local branch_name
            branch_name=${selected_branch#\[*\] }
                        
            if [ "$branch_name" != "$current_branch" ]; then
                git switch "$branch_name"
            fi
        fi
    }

    fi

fi
