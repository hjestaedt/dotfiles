#!/usr/bin/env bash

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias d+='pushd'
alias d-='popd'

# file listing
if [ is_macos ]; then
	alias ls='$MACOS_LS'
else
	alias ls='ls --color'
fi
alias ll='ls -lh'
alias la='ls -a'
alias lla='ll -a'
alias lt='ls -tra'
alias llt='ll -tra'
alias l.='ls -d .*'
alias ll.='ll -d .*'

# safety overrides
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'

# grep utilities
alias grep='grep --color=auto'
alias gri='grep -i'
alias gre='grep -E'           # extended regex
alias grf='grep -F'           # fixed string
alias agr='alias | grep'
alias agri='alias | grep -i'
alias egr='env | grep'
alias egri='env | grep -i'
alias hgr='history | grep'
alias hgri='history | grep -i'

# command overrides
alias top='htop'
alias ping='ping -c 5'
alias df='df -h'
alias du='du -ch'
alias diff='diff --color'
alias vi='vim'

# system info & utilities
alias cl='clear'
alias h='history'
alias path='echo -e ${PATH//:/\\n}'
alias sui='sudo -i'
alias sul='sudo su -l'
alias lsfn="declare -F | awk '{print \$NF}' | sort | egrep -v '^_'" # print all user defined functions

# date & time
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias nowdate='date "+%Y-%m-%d"'
alias nowtime='date "+%H:%M:%S"'
alias datetime='date "+%Y-%m-%d %H:%M:%S"'
alias datetime-file='date "+%Y%m%d_%H%M%S"'
alias timestamp='date +%s'

# fzf
if command -v fzf >/dev/null 2>&1; then
	alias afz='alias | sed "s/alias //" | fzf --preview "echo {}" --preview-window=down:1' # | cut -d"=" -f1'
	alias efz='env | fzf --preview "echo {}" --preview-window=down:1' # | cut -d"=" -f1'
fi
