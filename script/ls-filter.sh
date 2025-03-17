#!/usr/bin/env bash
#
# NAME:
#   ls-filter.sh - Enhanced ls command that filters out specified directories in HOME
#
# DESCRIPTION:
#   This script wraps the standard ls command to filter out specified directories
#   when listing contents in the user's home directory. It passes through all 
#   arguments to ls while adding --ignore flags for the specified directories.
#   The directories to ignore are read from a configuration file.
#
# USAGE:
#   ./ls-filter.sh [OPTIONS]
#   Where OPTIONS are standard ls options
#
#   or add an alias to your ~/.bashrc
#   alias ls='/path/to/ls-filter.sh -F --color=auto --group-directories-first'
#
# CONFIG:
#   The script reads the list of directories to ignore from:
#   ~/.config/ls-filter/config
#   Each line in the file represents one directory name to ignore.
#   If the config file doesn't exist, the script will create an empty config file.
#   With an empty config file, the script behaves like the regular ls command.

# Exit on undefined variables
set -u

# Define the base directory and config file paths
declare -r BASE_DIR="$HOME"
declare -r CONFIG_DIR="$HOME/.config/ls-filter"
declare -r CONFIG_FILE="$CONFIG_DIR/config"

# Function to load ignored directories from config file
function load_ignored_dirs() {
    # Check if config directory exists, if not create it
    if [[ ! -d "$CONFIG_DIR" ]]; then
        mkdir -p "$CONFIG_DIR"
    fi
    
    # Check if config file exists, if not create an empty one
    if [[ ! -f "$CONFIG_FILE" ]]; then
        # Create empty config file
        touch "$CONFIG_FILE"
        echo "Created empty config file at $CONFIG_FILE" >&2
    fi
    
    # Read config file line by line and output each non-empty, non-comment line
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        echo "$line"
    done < "$CONFIG_FILE"
}

# Check if a given path resolves to the base directory
function is_base_dir() {
    local real_path
    
    # Use realpath with -m flag to handle symlinks and nonexistent paths
    if command -v realpath >/dev/null 2>&1; then
        real_path=$(realpath -m "$1")
    else
        # Fallback to readlink if realpath is not available
        real_path=$(readlink -f "$1" || echo "$1")
    fi
    
    [[ "$real_path" == "$BASE_DIR" ]]
}

# Run ls with filters for ignored directories
function ls_filtered() {
    local ignore_args=()
    
    # Load ignored directories from config
    # Now the function will always create config if it doesn't exist
    mapfile -t IGNORED_DIRS < <(load_ignored_dirs)
    
    # Check if we have any directories to ignore
    if [[ ${#IGNORED_DIRS[@]} -eq 0 ]]; then
        # No directories to ignore, just run regular ls
        ls "$@"
        return $?
    fi
    
    # Construct ignore arguments for each directory
    for dir in "${IGNORED_DIRS[@]}"; do
        # Use printf to properly handle special characters in directory names
        ignore_args+=("--ignore=$(printf "%s" "$dir")")
    done
    
    # Execute ls with the original arguments plus ignore flags
    ls "$@" "${ignore_args[@]}"
    return $?
}

# Determine whether to apply filtering
function should_filter() {
    # Case 1: No arguments and in HOME directory
    if [ $# -eq 0 ] && is_base_dir "$(pwd)"; then
        return 0
    fi
    
    # Case 2: Any argument is HOME directory
    for arg in "$@"; do
        if [ -d "$arg" ] && is_base_dir "$arg"; then
            return 0
        fi
    done
    
    # Case 3: No directory args and current directory is HOME
    local has_dir_arg=false
    for arg in "$@"; do
        if [ -d "$arg" ]; then
            has_dir_arg=true
            break
        fi
    done
    
    if [ "$has_dir_arg" = false ] && is_base_dir "$(pwd)"; then
        return 0
    fi
    
    return 1
}

# Main execution
if should_filter "$@"; then
    ls_filtered "$@"
else
    ls "$@"
fi

# Exit with the exit code of the ls command
exit $?
