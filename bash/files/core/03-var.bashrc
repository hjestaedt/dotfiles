#!/usr/bin/env bash

# locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# editor
EDITOR=vim
VISUAL=vim
export EDITOR VISUAL

# history
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:la:cd:pwd:bg:fg:history"
export HISTSIZE HISTFILESIZE HISTCONTROL HISTIGNORE
