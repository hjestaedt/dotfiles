#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### command line options

usage() {
    echo "usage: $0 [OPTIONS]"
    echo ""
    echo "install starship configuration locally"
    echo ""
    echo "options:"
    echo "  -o, --overwrite          overwrite existing files without prompting"
    echo "  -s, --skip-backup        skip backing up existing files"
    echo "  -h, --help               show this help message and exit"
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

CONFIG_DIR="$HOME/.config"
CONFIG_FILE="$CONFIG_DIR/starship.toml"
BASHRC="$HOME/.bashrc"

# shellcheck disable=SC2016
STARSHIP_INIT='eval "$(starship init bash)"'

### functions

check_dependencies() {
    if ! command -v starship &> /dev/null; then
        echo "starship command is not available"
        exit 1
    fi
}

backup_files() {
    if [[ "$SKIP_BACKUP" == true ]]; then
        echo "skipping backup"
        return 0
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        local backup_file
        backup_file="${CONFIG_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing starship.toml to $backup_file"
        cp "$CONFIG_FILE" "$backup_file"
    fi
}

install_file() {
    local source_file="$SCRIPT_DIR/starship.toml"
    
    if [[ ! -f "$source_file" ]]; then
        echo "error: local starship config file not found: $source_file"
        return 1
    fi

    if [ ! -d "$CONFIG_DIR" ]; then
        echo "creating config directory $CONFIG_DIR..."
        mkdir -p "$CONFIG_DIR"
    fi

    echo "copying local starship config..."
    if ! cp "$source_file" "$CONFIG_FILE"; then
        echo "failed to copy local starship config from $source_file"
        return 1
    fi

    echo "starship config installed at $CONFIG_FILE"
    return 0
}

initialize() {
    local start_marker="# starship start"
    local end_marker="# starship end"
    local needs_update=false
    
    if [ -f "$BASHRC" ] && grep -q "$start_marker" "$BASHRC" && grep -q "$end_marker" "$BASHRC"; then
        echo "starship initialization already present in .bashrc"

        local existing_block
        existing_block=$(sed -n "/$start_marker/,/$end_marker/p" "$BASHRC")
        
        local expected_block
        expected_block=$(printf '%s\n%s\n%s' "$start_marker" "$STARSHIP_INIT" "$end_marker")
        
        if [ "$existing_block" = "$expected_block" ]; then
            echo "starship initialization already up to date"
            return 0
        else
            echo "updating starship initialization"
            needs_update=true
            # remove old block
            if ! sed -i "/$start_marker/,/$end_marker/d" "$BASHRC"; then
                echo "failed to update .bashrc"
                return 1
            fi
        fi
    else
        echo "adding starship initialization to .bashrc..."
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
            echo "$STARSHIP_INIT"
            echo "$end_marker"
        } >> "$BASHRC"
        echo "starship initialization added to .bashrc"
    fi
}

handle_existing_files() {
    if [[ "$OVERWRITE" == true ]]; then
        echo "overwriting existing config file $CONFIG_FILE"
        return 0
    fi
    
    echo "$CONFIG_FILE already exists."
    while read -r -p "do you want to override existing config file? (y/n): " response; do
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
echo "starship"
echo "####################"

check_dependencies

if [ -f "$CONFIG_FILE" ]; then
    handle_existing_files
fi

backup_files
install_file
initialize

echo "starship configuration installed successfully" 