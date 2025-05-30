#!/usr/bin/env bash

# terraform

if command -v kubectl >/dev/null 2>&1; then

    # terraform aliases
    alias tf="terraform"
    alias tfi="terraform init"
    alias tfa="terraform apply"
    alias tfd="terraform destroy"
    alias tff="terraform fmt -recursive -diff -no-color"
    alias tfp="terraform plan"
    alias tfs="terraform show"
	alias tfst="terraform state"
	alias tfws="terraform workspace"

    # terraform functions
    # todo: add functions
fi
