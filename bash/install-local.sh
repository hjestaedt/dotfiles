#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### command line options

usage() {
    echo "usage: $0 [OPTIONS]"
    echo ""
    echo "install bash configuration locally"
    echo ""
    echo "options:"
    echo "  -o, --overwrite        overwrite existing files without prompting"
    echo "  -s, --skip-backup      skip backing up existing files"
    echo "  -h, --help             show this help message and exit"
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

BASHRC_FILE="$HOME/.bashrc"
BASHRC_HOME="$HOME/.bashrc.d"

# detect operating system
os_name=$(uname -s)
if [ "$os_name" = "Linux" ]; then
    OS="linux"
elif [ "$os_name" = "Darwin" ]; then
    OS="macos"
else
    echo "error: unsupported os: $os_name" >&2
    exit 1
fi

FILE_DIR="$SCRIPT_DIR/files"
BASHRC_INIT_FILENAME="init.bashrc"

# shellcheck disable=SC2016
BASHRC_INIT_BLOCK='export BASHRC_HOME="$HOME/.bashrc.d"
if [ -d "$BASHRC_HOME" ] && [ -r "$BASHRC_HOME"/init.bashrc ]; then . "$BASHRC_HOME"/init.bashrc; fi'

### functions

check_dependencies() {
    if ! command -v bash &> /dev/null; then
        echo "bash command is not available"
        exit 1
    fi
}

backup_files() {
    if [[ "$SKIP_BACKUP" == true ]]; then
        echo "skipping backup"
        return 0
    fi
    
    if [ -d "$BASHRC_HOME" ]; then
        local backup_dir
        backup_dir="${BASHRC_HOME}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing .bashrc.d to $backup_dir"
        cp -r "$BASHRC_HOME" "$backup_dir"
    fi
}

create_base_files() {
    # create $BASHRC_HOME if not exists
    if [ ! -d "$BASHRC_HOME" ]; then
        echo "creating $BASHRC_HOME"
        mkdir -p "$BASHRC_HOME"
    fi
}

install_files_from_dir() {
    local src_dir="$1"
    local dst_dir="$2"
    
    if [ ! -d "$src_dir" ]; then
        echo "warning: source directory not found: $src_dir"
        return 0
    fi
    
    # create destination directory if it doesn't exist
    if [ ! -d "$dst_dir" ]; then
        echo "creating $dst_dir"
        mkdir -p "$dst_dir"
    fi
    
    for file in "$src_dir"/*; do
        if [ -f "$file" ]; then
            echo "installing $(basename "$file") to $dst_dir"
            if [ "$OVERWRITE" = true ]; then
                cp -f "$file" "$dst_dir"
            else
                cp "$file" "$dst_dir"
            fi
        fi
    done
}

install_bash_file() {
	local bash_file="$1"
	local src_file="$FILE_DIR/$1"
	local dst_file="$BASHRC_HOME/$1"

    if [ -f "$src_file" ]; then
        echo "installing $bash_file to $dst_file"
        cp "$src_file" "$dst_file"
    else
        echo "error: $src_file not found"
        return 1
    fi
}

install_bash_files() {
    echo "installing bash configuration files for os: $OS"
    
    # copy dotfile hierarchy to $BASHRC_HOME
    for src_subdir in "core" "tool" "user"; do
        local src_dir="$FILE_DIR/$src_subdir"
        local dst_dir="$BASHRC_HOME/$src_subdir"
        install_files_from_dir "$src_dir" "$dst_dir"
    done

	# copy os/$OS.bashc to $BASHRC_HOME
	if [ ! -d "$BASHRC_HOME/os" ]; then
		mkdir -p "$BASHRC_HOME/os"
	fi
	install_bash_file "os/$OS.bashrc"

    # copy init.bashrc to $BASHRC_HOME
	install_bash_file "$BASHRC_INIT_FILENAME"
}

initialize_bashrc() {
    local start_marker="# bashrc.d start"
    local end_marker="# bashrc.d end"
    local needs_update=false
    
    if [ -f "$BASHRC_FILE" ] && grep -q "$start_marker" "$BASHRC_FILE" && grep -q "$end_marker" "$BASHRC_FILE"; then
        echo "bashrc.d initialization already present in .bashrc"

        local existing_block
        existing_block=$(sed -n "/$start_marker/,/$end_marker/p" "$BASHRC_FILE")
        
        local expected_block
        expected_block=$(printf '%s\n%s\n%s' "$start_marker" "$BASHRC_INIT_BLOCK" "$end_marker")
        
        if [ "$existing_block" = "$expected_block" ]; then
            echo "bashrc.d initialization already up to date"
            return 0
        else
            echo "updating bashrc.d initialization"
            needs_update=true
            # remove old block
            if ! sed -i "/$start_marker/,/$end_marker/d" "$BASHRC_FILE"; then
                echo "failed to update .bashrc"
                return 1
            fi
        fi
    else
        echo "adding bashrc.d initialization to .bashrc..."
        needs_update=true
    fi
    
    # backup before modifying (only if we're going to modify)
    if [[ "$needs_update" == true ]] && [[ "$SKIP_BACKUP" == false ]] && [ -f "$BASHRC_FILE" ]; then
        local backup_file
        backup_file="${BASHRC_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing .bashrc to $backup_file"
        cp "$BASHRC_FILE" "$backup_file"
    fi
    
    # add initialization block (only if we're going to modify)
    if [[ "$needs_update" == true ]]; then
        {
            echo
            echo "$start_marker"
            echo "$BASHRC_INIT_BLOCK"
            echo "$end_marker"
        } >> "$BASHRC_FILE"
        echo "bashrc.d initialization added to .bashrc"
    fi
}

handle_existing_files() {
    if [[ "$OVERWRITE" == true ]]; then
        echo "overwriting existing bash configuration"
        return 0
    fi
    
    if [ -d "$BASHRC_HOME" ]; then
        echo "$BASHRC_HOME already exists."
        while read -r -p "do you want to override existing bash configuration? (y/n): " response; do
            case "$response" in
                [Yy]*) return 0 ;;
                [Nn]*) echo "aborting script"; exit 0 ;;
                *) echo "invalid input, please enter 'y' or 'n'" ;;
            esac
        done
    fi
}

### main script

echo ""
echo "####################"
echo "bash"
echo "####################"

check_dependencies

if [ -d "$BASHRC_HOME" ]; then
    handle_existing_files
fi

backup_files
create_base_files
install_bash_files
initialize_bashrc

echo "bash configuration installed successfully" 
