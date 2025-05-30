#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### command line options

usage() {
    echo "usage: $0 [OPTIONS]"
    echo ""
    echo "install dircolors configuration locally"
    echo ""
    echo "options:"
    echo "  -o, --overwrite      overwrite existing files without prompting"
    echo "  -s, --skip-backup    skip backing up existing files"
    echo "  -h, --help           show this help message and exit"
}

OVERWRITE=false
SKIP_BACKUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--overwrite) OVERWRITE=true; shift ;;
        -s|--skip-backup) SKIP_BACKUP=true; shift ;;
        -h|--help) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

### variables

DIRCOLORS_FILE="$HOME/.dircolors"
BASHRC="$HOME/.bashrc"

# shellcheck disable=SC2016
DIRCOLORS_INIT='test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"'

### functions

check_dependencies() {
    if ! command -v dircolors &> /dev/null; then
        echo "dircolors command is not available"
        exit 1
    fi
}

backup_files() {
    if [[ "$SKIP_BACKUP" == true ]]; then
        echo "skipping backup"
        return 0
    fi
    
    if [ -f "$DIRCOLORS_FILE" ]; then
        local backup_file
        backup_file="${DIRCOLORS_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing .dircolors to $backup_file"
        cp "$DIRCOLORS_FILE" "$backup_file"
    fi
}

install_file() {
    local dircolors_source="$SCRIPT_DIR/dircolors"
    
    if [[ ! -f "$dircolors_source" ]]; then
        echo "error: local dircolors file not found: $dircolors_source"
        return 1
    fi

    if ! dircolors "$dircolors_source" > /dev/null 2>&1; then
        echo "warning: dircolors file may be invalid"
    fi

    echo "copying local dircolors..."
    if ! cp "$dircolors_source" "$DIRCOLORS_FILE"; then
        echo "failed to copy local dircolors from $dircolors_source"
        return 1
    fi

    echo "dircolors installed at $DIRCOLORS_FILE"
    return 0
}

initialize() {
    local start_marker="# dircolors start"
    local end_marker="# dircolors end"
    local needs_update=false
    
    if [ -f "$BASHRC" ] && grep -q "$start_marker" "$BASHRC" && grep -q "$end_marker" "$BASHRC"; then
        echo "dircolors initialization already present in .bashrc"

        local existing_block
        existing_block=$(sed -n "/$start_marker/,/$end_marker/p" "$BASHRC")
        
        local expected_block
        expected_block=$(printf '%s\n%s\n%s' "$start_marker" "$DIRCOLORS_INIT" "$end_marker")
        
        if [ "$existing_block" = "$expected_block" ]; then
            echo "dircolors initialization already up to date"
            return 0
        else
            echo "updating dircolors initialization"
            needs_update=true
            # remove old block
            if ! sed -i "/$start_marker/,/$end_marker/d" "$BASHRC"; then
                echo "failed to update .bashrc"
                return 1
            fi
        fi
    else
        echo "adding dircolors initialization to .bashrc..."
        needs_update=true
    fi
    
    # backup before modifying (only if we're going to modify)
    if [[ "$needs_update" == true ]] && [[ "$SKIP_BACKUP" == false ]] && [ -f "$BASHRC" ]; then
        local backup_file
        backup_file="${BASHRC}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing .bashrc to $backup_file"
        cp "$BASHRC" "$backup_file"
    fi
    
    # add initialization block (only if we're going to modify)
    if [[ "$needs_update" == true ]]; then
        {
            echo
            echo "$start_marker"
            echo "$DIRCOLORS_INIT"
            echo "$end_marker"
        } >> "$BASHRC"
        echo "dircolors initialization added to .bashrc"
    fi
}

handle_existing_files() {
    if [[ "$OVERWRITE" == true ]]; then
        echo "overwriting existing files"
        return 0
    fi
    
    echo "$DIRCOLORS_FILE already exists."
    while read -r -p "do you want to override existing files? (y/n): " response; do
        case "$response" in
            [Yy]*) return 0 ;;
            [Nn]*) echo "aborting script"; exit 0 ;;
            *) echo "invalid input, please enter 'y' or 'n'" ;;
        esac
    done
}

### main script 

echo ""
echo "####################"
echo "dircolors"
echo "####################"

check_dependencies

if [ -f "$DIRCOLORS_FILE" ]; then
    handle_existing_files
fi

backup_files
install_file
initialize

echo "dircolors installed successfully" 