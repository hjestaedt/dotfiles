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
    # TODO: add functions
fi
