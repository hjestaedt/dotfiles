#!/usr/bin/env bash

init_bashrc() {
    variable_set "$BASHRC_HOME" || exit_error "\$BASHRC_HOME must be set"
    for file in "$BASHRC_HOME"/*.bashrc; do
      # shellcheck disable=SC1090
      . "$file"
    done
}

# description:
#   set terminal tab name
#   if tabname is not provided, the tab name is reset to default
# arguments:
#   tabname - tab name (optional)
# usage:
#   set_tabname [tabname]
#   e.g.: set_tabname foo
#   e.g.: set_tabname
set_tabname() {
    echo -en "\033]0;$1\a"
}

# description:
#   # highlight pattern in the fiven input
# arguments:
#   pattern - pattern to highlight
# usage:
#   highlight <pattern>
#   cat <file> | highlight foo
#   cat <file> | highlight "foo\|bar"
#   cat <file> | highlight "foo\|bar" | less -r
highlight() {
    variable_set "$1" || exit_error "pattern argument required"
    local escape
    escape=$(printf '\033')
    local color=31
    sed "s,${1},${escape}[${color}m&${escape}[0m,g"
}