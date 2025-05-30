#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### command line options

usage() {
    echo "usage: $0 [OPTIONS]"
    echo ""
    echo "install tmux configuration locally"
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

CONF_DIR="$HOME/.config/tmux"
CONF_FILE="$CONF_DIR/tmux.conf"
TPM_DIR="$CONF_DIR/plugins/tpm"
INSTALL_TPM=false

### functions

check_dependencies() {
    if ! command -v tmux &> /dev/null; then
        echo "tmux command is not available"
        exit 1
    fi
}

prompt_tpm_installation() {
    while read -r -p "do you want to install tpm (tmux plugin manager)? (y/n): " response; do
        case "$response" in
            [Yy]*) INSTALL_TPM=true; return 0 ;;
            [Nn]*) INSTALL_TPM=false; return 0 ;;
            *) echo "invalid input, please enter 'y' or 'n'" ;;
        esac
    done
}

create_home() {
    if [ ! -d "$CONF_DIR" ]; then
        echo "creating tmux config directory $CONF_DIR"
        mkdir -p "$CONF_DIR"
    fi
}

backup_files() {
    if [[ "$SKIP_BACKUP" == true ]]; then
        echo "skipping backup"
        return 0
    fi
    
    if [ -f "$CONF_FILE" ]; then
        local backup_file
        backup_file="${CONF_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "backing up existing tmux.conf to $backup_file"
        cp "$CONF_FILE" "$backup_file"
    fi
}

install_file() {
    local source_file
    if $INSTALL_TPM; then
        source_file="$SCRIPT_DIR/tmux.conf"
    else
        source_file="$SCRIPT_DIR/tmux-base.conf"
    fi
    
    if [[ ! -f "$source_file" ]]; then
        echo "error: local file not found: $source_file"
        return 1
    fi

    create_home
    
    echo "copying local tmux.conf..."
    if ! cp "$source_file" "$CONF_FILE"; then
        echo "failed to copy local file from $source_file"
        return 1
    fi
    
    chmod 644 "$CONF_FILE"
    echo "tmux.conf installed at $CONF_FILE"
    return 0
}

install_tpm() {
    if [ ! -d "$TPM_DIR" ]; then
        echo "installing tmux plugin manager (tpm)..."
        if ! git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
            echo "failed to clone tpm repository"
            return 1
        fi
    else
        echo "updating tmux plugin manager (tpm)..."
        if ! (cd "$TPM_DIR" && git pull); then
            echo "failed to update tpm repository"
            return 1
        fi
    fi
    return 0
}

handle_existing_files() {
    if [[ "$OVERWRITE" == true ]]; then
        echo "overwriting existing file $CONF_FILE"
        return 0
    fi
    
    echo "$CONF_FILE already exists."
    while read -r -p "do you want to override the existing file? (y/n): " response; do
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
echo "tmux"
echo "####################"

check_dependencies
prompt_tpm_installation

if [ -f "$CONF_FILE" ]; then
    handle_existing_files
fi

backup_files
install_file

if $INSTALL_TPM; then
    install_tpm
fi

echo "tmux configuration installed successfully" 