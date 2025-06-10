#!/usr/bin/env bash

if command -v terraform >/dev/null 2>&1; then

    # terraform aliases
	
	# terraform
	# https://developer.hashicorp.com/terraform/cli
    alias tf="terraform"

	# terraform init
	# https://developer.hashicorp.com/terraform/cli/commands/init
    alias tfini="terraform init"
    alias tfiniupg="terraform init --upgrade"

	# terraform fmt
	# https://developer.hashicorp.com/terraform/cli/commands/fmt
    alias tffmt="terraform fmt -recursive -diff"

	# terraform validate
	# https://developer.hashicorp.com/terraform/cli/commands/validate
    alias tfval="terraform validate"
	
	# terraform show
	# https://developer.hashicorp.com/terraform/cli/commands/show
    alias tfsh="terraform show"

	# terraform plan
	# https://developer.hashicorp.com/terraform/cli/commands/plan
	alias tfpln="terraform plan"

	# terraform apply
	# https://developer.hashicorp.com/terraform/cli/commands/apply
	alias tfap="terraform apply"

	# terraform refresh
	# https://developer.hashicorp.com/terraform/cli/commands/refresh
    alias tfrfr="terraform refresh"

	# terraform destroy
	# https://developer.hashicorp.com/terraform/cli/commands/destroy
    alias tfdst="terraform destroy"

	# terraform output
	# https://developer.hashicorp.com/terraform/cli/commands/output
    alias tfout="terraform output"

	# terraform state
	# https://developer.hashicorp.com/terraform/cli/commands/state
    alias tfst="terraform state"
    alias tfstls="terraform state list"
    alias tfstsh="terraform state show"

	# terraform workspace
	# https://developer.hashicorp.com/terraform/cli/commands/workspace
    alias tfws="terraform workspace"
    alias tfwsls="terraform workspace list"
    alias tfwsse="terraform workspace select"

    # terraform functions

    # tfdbl - disable terraform file by adding .disabled suffix
    # description:
    #   disable a terraform file by renaming it with a .disabled suffix
    #   only adds suffix if not already present
    # arguments:
    #   file - name of the file to disable
    # usage:
    #   tfdbl <file>
    #   e.g.: tfdbl main.tf, tfdbl variables.tf
    tfdbl() {
        [ -n "$1" ] || { echo "file argument required" >&2; return 1; }
        [ -f "$1" ] || { echo "file $1 not found" >&2; return 1; }
        case "$1" in
            *.disabled) echo "file $1 is already disabled" >&2; return 1 ;;
            *) mv "$1" "${1}.disabled" && echo "file $1 disabled" >&2 ;;
        esac
    }

    # tfebl - enable terraform file by removing .disabled suffix
    # description:
    #   enable a terraform file by removing the .disabled suffix from its name
    #   only removes suffix if present
    # arguments:
    #   file - name of the disabled file to enable
    # usage:
    #   tfebl <file>
    #   e.g.: tfebl main.tf.disabled, tfebl variables.tf.disabled
    tfebl() {
        [ -n "$1" ] || { echo "file argument required" >&2; return 1; }
        [ -f "$1" ] || { echo "file $1 not found" >&2; return 1; }
        case "$1" in
            *.disabled) mv "$1" "${1%%.disabled}" && echo "file $1 enabled" >&2 ;;
            *) echo "file $1 does not have .disabled suffix" >&2; return 1 ;;
        esac
    }
fi
