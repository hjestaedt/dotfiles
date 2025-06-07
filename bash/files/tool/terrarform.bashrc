#!/usr/bin/env bash

if command -v terraform >/dev/null 2>&1; then

    # terraform aliases
    alias trf="terraform"
    alias trfap="terraform apply"
    alias trfdst="terraform destroy"
    alias trffmt="terraform fmt -recursive -diff -no-color"
    alias trfini="terraform init"
    alias trfout="terraform output"
    alias trfpn="terraform plan"
    alias trfrfr="terraform refresh"
    alias trfsh="terraform show"
    alias trfst="terraform state"
    alias trfstls="terraform state list"
    alias trfstsh="terraform state show"
    alias trfval="terraform validate"
    alias trfws="terraform workspace"
    alias trfwsls="terraform workspace list"
    alias trfwsse="terraform workspace select"

    # terraform functions
    # todo: add functions
fi
