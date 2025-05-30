#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_BACKUP=false
OVERWRITE=false
ALL=false
SPECIFIED_CONFIGS=()
FAILED_CONFIGS=()

show_usage() {
    echo "usage: $0 [OPTIONS] [CONFIGS...]"
    echo ""
    echo "installs dotfiles locally"
    echo ""
    echo "options:"
    echo "  -a, --all          install all configurations without prompting"
    echo "  -o, --overwrite    overwrite existing files without prompting"
    echo "  -s, --skip-backup  skip creating backups of existing files"
    echo "  -h, --help         show this help message"
    echo ""
    echo "arguments:"
    echo "  CONFIGS            specific configurations to install (bash,dircolors, gitconfig, starship, tmux, vimrc)"
    echo "                     if none specified, all configurations will be prompted (unless --all is used)"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--all) ALL=true ;;
        -o|--overwrite) OVERWRITE=true ;;
        -s|--skip-backup) SKIP_BACKUP=true ;;
        -h|--help) show_usage; exit 0 ;;
        -*) echo "unknown option: $1"; show_usage; exit 1 ;;
        *) SPECIFIED_CONFIGS+=("$1") ;;
    esac
    shift
done

declare -A config_scripts=(
    ["bash"]="bash/install-local.sh"
    ["dircolors"]="dircolors/install-local.sh"
    ["gitconfig"]="gitconfig/install-local.sh"
    ["starship"]="starship/install-local.sh"
    ["tmux"]="tmux/install-local.sh"
    ["vimrc"]="vimrc/install-local.sh"
)

# Validate specified configs
if [[ ${#SPECIFIED_CONFIGS[@]} -gt 0 ]]; then
    for config in "${SPECIFIED_CONFIGS[@]}"; do
        if [[ ! ${config_scripts[$config]+_} ]]; then
            echo "error: unknown configuration '$config'"
            echo "available configurations: ${!config_scripts[*]}"
            exit 1
        fi
    done
    CONFIGS_TO_PROCESS=("${SPECIFIED_CONFIGS[@]}")
else
    CONFIGS_TO_PROCESS=("${!config_scripts[@]}")
fi

install_config() {
    local config="$1"
    echo "installing $config dotfiles..."
    
    local script="$SCRIPT_DIR/${config_scripts[$config]}"
    if [[ ! -f "$script" ]]; then
        echo "error: script not found: $script"
        FAILED_CONFIGS+=("$config")
        return 1
    fi
    
    echo "running installer: $script"
    local script_args=()
    if [[ "$OVERWRITE" == true ]]; then
        script_args+=("--overwrite")
    fi
    if [[ "$SKIP_BACKUP" == true ]]; then
        script_args+=("--skip-backup")
    fi
    
    if ! /usr/bin/env bash "$script" "${script_args[@]}"; then
        echo "error: failed to execute $script"
        FAILED_CONFIGS+=("$config")
        return 1
    fi
    
    echo "$config configuration installed successfully"
}

for config in "${CONFIGS_TO_PROCESS[@]}"; do
    echo ""
    
    # if specific configs were provided or all flag is set, install automatically without prompting
    if [[ ${#SPECIFIED_CONFIGS[@]} -gt 0 ]] || [[ "$ALL" == true ]]; then
        install_config "$config" || true  # don't exit on failure
    else
        # no specific configs provided and no all flag, prompt for each one
        read -rp "do you want to install $config config? (y/n): " response
        case "${response,,}" in
            y|yes) install_config "$config" || true ;;  # don't exit on failure
            n|no) echo "skipping $config configuration" ;;
            *) echo "invalid response. please enter y/yes or n/no" ;;
        esac
    fi
done

# Report results
echo ""
echo "##################"
echo "Installation Summary"
echo "##################"

if [[ ${#FAILED_CONFIGS[@]} -eq 0 ]]; then
    echo "✓ All configurations installed successfully!"
else
    echo "✗ Some configurations failed to install:"
    for failed_config in "${FAILED_CONFIGS[@]}"; do
        echo "  - $failed_config"
    done
    echo ""
    echo "Successfully installed:"
    for config in "${CONFIGS_TO_PROCESS[@]}"; do
        if [[ ! " ${FAILED_CONFIGS[*]} " =~ " ${config} " ]]; then
            echo "  - $config"
        fi
    done
    exit 1
fi 