#!/usr/bin/env bash

if command -v terraform >/dev/null 2>&1; then

    # terraform aliases

    # terraform
    # https://developer.hashicorp.com/terraform/cli
    alias tf="terraform"

    # terraform validate
    # https://developer.hashicorp.com/terraform/cli/commands/validate
    alias tfval="terraform validate"

    # terraform fmt
    # https://developer.hashicorp.com/terraform/cli/commands/fmt
    alias tffmt="terraform fmt -recursive -diff"

    # terraform init
    # https://developer.hashicorp.com/terraform/cli/commands/init
    alias tfini="terraform init"
    alias tfiniupg="terraform init --upgrade"

    # terraform plan
    # https://developer.hashicorp.com/terraform/cli/commands/plan
    alias tfpln="terraform plan"

    # terraform apply
    # https://developer.hashicorp.com/terraform/cli/commands/apply
    alias tfap="terraform apply"

    # terraform destroy
    # https://developer.hashicorp.com/terraform/cli/commands/destroy
    alias tfdst="terraform destroy"

    # terraform refresh
    # https://developer.hashicorp.com/terraform/cli/commands/refresh
    alias tfrfr="terraform refresh"

    # terraform output
    # https://developer.hashicorp.com/terraform/cli/commands/output
    alias tfout="terraform output"

    # terraform state
    # https://developer.hashicorp.com/terraform/cli/commands/state
    alias tfstt="terraform state"
    alias tfsttls="terraform state list"
    alias tfsttsh="terraform state show"

    # terraform show
    # https://developer.hashicorp.com/terraform/cli/commands/show
    alias tfsh="terraform show"

    # terraform workspace
    # https://developer.hashicorp.com/terraform/cli/commands/workspace
    alias tfws="terraform workspace"
    alias tfwsls="terraform workspace list"
    alias tfwsse="terraform workspace select"

    # terraform functions

    # tfdbl - disable terraform files by adding .disabled suffix
    # description:
    #   disable terraform files by renaming them with a .disabled suffix
    #   only adds suffix if not already present
    # arguments:
    #   files - names of the files to disable
    # usage:
    #   tfdbl <file1> [file2] [file3] ...
    #   e.g.: tfdbl main.tf
    #   e.g.: tfdbl variables.tf outputs.tf
    tfdbl() {
        [ $# -eq 0 ] && {
            echo "at least one file argument required" >&2
            return 1
        }
        
        local exit_code=0

        for file in "$@"; do
            if [ ! -f "$file" ]; then
                echo "file $file not found" >&2
                exit_code=1
                continue
            fi

            case "$file" in
            *.disabled)
                echo "file $file is already disabled" >&2
                exit_code=1
                ;;
            *)
                if mv "$file" "${file}.disabled"; then
                    echo "file $file disabled" >&2
                else
                    echo "failed to disable file $file" >&2
                    exit_code=1
                fi
                ;;
            esac
        done

        return $exit_code
    }

    # tfebl - enable terraform files by removing .disabled suffix
    # description:
    #   enable terraform files by removing the .disabled suffix from their names
    #   accepts both foo.tf and foo.tf.disabled as input
    # arguments:
    #   files - names of the files to enable (with or without .disabled suffix)
    # usage:
    #   tfebl <file1> [file2] [file3] ...
    #   e.g.: tfebl main.tf, tfebl variables.tf.disabled outputs.tf
    tfebl() {
        [ $# -eq 0 ] && {
            echo "at least one file argument required" >&2
            return 1
        }

        local exit_code=0

        for file in "$@"; do
            local disabled_file

            case "$file" in
            *.disabled)
                disabled_file="$file"
                ;;
            *)
                disabled_file="${file}.disabled"
                ;;
            esac

            if [ ! -f "$disabled_file" ]; then
                echo "file $disabled_file not found" >&2
                exit_code=1
                continue
            fi

            local enabled_file="${disabled_file%%.disabled}"

            if mv "$disabled_file" "$enabled_file"; then
                echo "file $disabled_file enabled" >&2
            else
                echo "failed to enable file $disabled_file" >&2
                exit_code=1
            fi
        done

        return $exit_code
    }
fi
