#!/usr/bin/env bash

# variables
BACKUP_DIR="$HOME/var/backup"
DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
export BACKUP_DIR DOCKER_HOST 

# functions
difftool() {
    # shellcheck disable=SC2068
    "$HOME"/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea diff $@ &>/dev/null
}
