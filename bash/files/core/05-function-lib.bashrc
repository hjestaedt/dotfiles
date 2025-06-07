#!/usr/bin/env bash

# description:
#   exit with error code and optional error message
# arguments:
#   optional: exit_code - numeric exit code (default: 1)
#   optional: message - error message (if exit_code provided, this is $2; otherwise $1)
# returns:
#   specified exit code or 1
# usage:
#   exit_error
#   exit_error <exit_code>
#   exit_error <message>
#   exit_error <exit_code> <message>
# example:
#   exit_error
#   exit_error 2
#   exit_error "file not found"
#   exit_error 2 "invalid argument"
# note:
#   purely numeric messages will be interpreted as exit codes
exit_error() {
    local exit_code=1
    local message=""
    
 	if [ -z "$1" ]; then
        exit "$exit_code"
    elif [[ "$1" =~ ^[0-9]+$ ]]; then
        exit_code="$1"
        [ -n "$2" ] && message="$2"
    else
        message="$1"
    fi
    
    [ -n "$message" ] && echo "error: $message" >&2
    exit "$exit_code"
}

# description:
#   log error to stderr
# arguments:
#   optional: message - error message
# returns:
#   0
# usage:
#   log_error message
log_error() {
	[ -z "$1" ] && { echo "error: message argument is required" >&2; return 1;}
	echo "error: $1" >&2
}

# description:
#   check if command exists
# arguments:
#   command - command to check
# returns:
#   0 - command exists
#   1 - command does not exist
# usage:
#   command_exists <command>
# example:
#   command_exists git
command_exists() {
    [ -z "$1" ] && { echo "error: command argument is required" >&2; return 1;}
    command -v "$1" >/dev/null 2>&1
}
