#!/usr/bin/env bash

# terraform

if command -v terraform >/dev/null 2>&1; then

    # terraform aliases
    alias tf="terraform"
    alias tfi="terraform init"
    alias tfa="terraform apply"
    alias tfd="terraform destroy"
    alias tff="terraform fmt -recursive -diff -no-color"
    alias tfp="terraform plan"
    alias tfs="terraform show"
    alias tfst="terraform state"
    alias tfstl="terraform state list"
    alias tfsts="terraform state show"
    alias tfws="terraform workspace"
    alias tfwsl="terraform workspace list"
    alias tfwss="terraform workspace select"
    alias tfv="terraform validate"
    alias tfo="terraform output"

    # terraform functions
    # todo: add functions
fi
