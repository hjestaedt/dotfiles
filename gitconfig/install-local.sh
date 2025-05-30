#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### command line options

usage() {
    echo "usage: $0 [OPTIONS]"
    echo ""
    echo "install gitconfig configuration locally"
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

GITCONFIG_FILE="$HOME/.gitconfig"
GITIGNORE_FILE="$HOME/.gitignore"

### functions

check_dependencies() {
    if ! command -v git &> /dev/null; then
        echo "git command is not available"
        exit 1
    fi
}

backup_files() {
    if [[ "$SKIP_BACKUP" == true ]]; then
        echo "skipping backup"
        return 0
    fi
    
    if [ -f "$GITCONFIG_FILE" ]; then
        local backup_file
        backup_file="${GITCONFIG_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing .gitconfig to $backup_file"
        cp "$GITCONFIG_FILE" "$backup_file"
    fi
    
    if [ -f "$GITIGNORE_FILE" ]; then
        local backup_file
        backup_file="${GITIGNORE_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing .gitignore to $backup_file"
        cp "$GITIGNORE_FILE" "$backup_file"
    fi
}

install_file() {
    local gitconfig_source="$SCRIPT_DIR/gitconfig"
    local gitignore_source="$SCRIPT_DIR/gitignore"
    
    if [[ ! -f "$gitconfig_source" ]]; then
        echo "error: local gitconfig file not found: $gitconfig_source"
        return 1
    fi
    
    if [[ ! -f "$gitignore_source" ]]; then
        echo "error: local gitignore file not found: $gitignore_source"
        return 1
    fi

    echo "copying local gitconfig and gitignore..."
    if ! cp "$gitconfig_source" "$GITCONFIG_FILE"; then
        echo "failed to copy local gitconfig from $gitconfig_source"
        return 1
    fi
    
    if ! cp "$gitignore_source" "$GITIGNORE_FILE"; then
        echo "failed to copy local gitignore from $gitignore_source"
        return 1
    fi

    echo "gitconfig installed at $GITCONFIG_FILE"
    echo "gitignore installed at $GITIGNORE_FILE"
    return 0
}

handle_existing_files() {
    if [[ "$OVERWRITE" == true ]]; then
        echo "overwriting existing files"
        return 0
    fi
    
    echo "$GITCONFIG_FILE already exists."
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
echo "gitconfig"
echo "####################"

check_dependencies

if [ -f "$GITCONFIG_FILE" ]; then
    handle_existing_files
fi

backup_files
install_file

echo "gitconfig and gitignore installed successfully" 