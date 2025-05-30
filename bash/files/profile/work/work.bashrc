#!/usr/bin/env bash

# variables
DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
JQ_COLORS="0;90:0;39:0;39:0;39:0;32:1;39:1;39:1;34"
export DOCKER_HOST JQ_COLORS SHELL_CONFIG

# path
PATH="$JAVA_HOME/bin:$PATH"
PATH="$HOME/opt/cli/build/maven/bin:$PATH"
export PATH

# functions
difftool() {
    # shellcheck disable=SC2068
    "$HOME"/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea diff $@ &>/dev/null
}
