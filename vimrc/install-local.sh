#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### command line options

usage() {
    echo "usage: $0 [OPTIONS]"
    echo ""
    echo "install vimrc configuration locally"
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

VIMRC_FILE="$HOME/.vimrc"

### functions

check_dependencies() {
    if ! command -v vim &> /dev/null; then
        echo "vim command is not available"
        exit 1
    fi
}

backup_files() {
    if [[ "$SKIP_BACKUP" == true ]]; then
        echo "skipping backup"
        return 0
    fi
    
    if [ -f "$VIMRC_FILE" ]; then
        local backup_file
        backup_file="${VIMRC_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing .vimrc to $backup_file"
        cp "$VIMRC_FILE" "$backup_file"
    fi
}

install_file() {
    local vimrc_source="$SCRIPT_DIR/vimrc"
    
    if [[ ! -f "$vimrc_source" ]]; then
        echo "error: local vimrc file not found: $vimrc_source"
        return 1
    fi

    echo "copying local vimrc..."
    if ! cp "$vimrc_source" "$VIMRC_FILE"; then
        echo "failed to copy local vimrc from $vimrc_source"
        return 1
    fi

    echo "vimrc installed at $VIMRC_FILE"
    return 0
}

handle_existing_files() {
    if [[ "$OVERWRITE" == true ]]; then
        echo "overwriting existing file $VIMRC_FILE"
        return 0
    fi
    
    echo "$VIMRC_FILE already exists."
    while read -r -p "do you want to override existing file? (y/n): " response; do
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
echo "vimrc"
echo "####################"

check_dependencies

if [ -f "$VIMRC_FILE" ]; then
    handle_existing_files
fi

backup_files
install_file

echo "vimrc installed successfully" 