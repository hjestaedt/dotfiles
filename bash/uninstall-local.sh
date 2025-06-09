#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### command line options

usage() {
    echo "usage: $0 [OPTIONS]"
    echo ""
    echo "uninstall bash configuration"
    echo ""
    echo "options:"
    echo "  -f, --force            remove files without prompting"
    echo "  -s, --skip-backup      skip backing up existing files"
    echo "  -h, --help             show this help message and exit"
}

FORCE=false
SKIP_BACKUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force) FORCE=true; shift ;;
        -s|--skip-backup) SKIP_BACKUP=true; shift ;;
        -h|--help) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

### variables

BASHRC_FILE="$HOME/.bashrc"
BASHRC_HOME="$HOME/.bashrc.d"

### functions

remove_bashrc_initialization() {
    local start_marker="# bashrc.d start"
    local end_marker="# bashrc.d end"
    
    if [ ! -f "$BASHRC_FILE" ]; then
        echo "no .bashrc file found"
        return 0
    fi
    
    if ! grep -q "$start_marker" "$BASHRC_FILE" || ! grep -q "$end_marker" "$BASHRC_FILE"; then
        echo "bashrc.d initialization not found in .bashrc"
        return 0
    fi
    
    echo "removing bashrc.d initialization from .bashrc"
    
    # create backup before modifying (unless skipping backup)
    if [[ "$SKIP_BACKUP" == false ]]; then
        local backup_file
        backup_file="${BASHRC_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up .bashrc to $backup_file"
        cp "$BASHRC_FILE" "$backup_file"
    else
        echo "skipping backup of .bashrc"
    fi
    
    # remove the bashrc.d block
    if sed -i.bak "/$start_marker/,/$end_marker/d" "$BASHRC_FILE"; then
        echo "bashrc.d initialization removed from .bashrc"
        # remove the backup file created by sed
        rm -f "${BASHRC_FILE}.bak"
    else
        echo "failed to remove bashrc.d initialization from .bashrc"
        return 1
    fi
}

remove_bashrc_directory() {
    if [ ! -d "$BASHRC_HOME" ]; then
        echo "no .bashrc.d directory found"
        return 0
    fi
    
    echo "removing $BASHRC_HOME directory"
    
    # create backup before removing (unless skipping backup)
    if [[ "$SKIP_BACKUP" == false ]]; then
        local backup_dir
        backup_dir="${BASHRC_HOME}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up .bashrc.d to $backup_dir"
        cp -r "$BASHRC_HOME" "$backup_dir"
    else
        echo "skipping backup of .bashrc.d"
    fi
    
    # remove the directory
    if rm -rf "$BASHRC_HOME"; then
        echo "$BASHRC_HOME directory removed"
    else
        echo "failed to remove $BASHRC_HOME directory"
        return 1
    fi
}

confirm_uninstall() {
    if [ "$FORCE" = true ]; then
        return 0
    fi
    
    echo "this will remove the bash configuration and .bashrc.d directory"
    echo ""
    
    while true; do
        printf "do you want to continue? (y/n): "
        read -r response
        case "$response" in
            [Yy]*) return 0 ;;
            [Nn]*) echo "aborting uninstall"; exit 0 ;;
            *) echo "invalid input, please enter 'y' or 'n'" ;;
        esac
    done
}

### main script

echo ""
echo "####################"
echo "bash uninstall"
echo "####################"

confirm_uninstall

remove_bashrc_initialization
remove_bashrc_directory

echo "bash configuration uninstalled successfully" 