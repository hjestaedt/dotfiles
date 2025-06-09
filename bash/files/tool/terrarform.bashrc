#!/usr/bin/env bash

if command -v terraform >/dev/null 2>&1; then

    # terraform aliases
    alias tf="terraform"
    alias tfap="terraform apply"
    alias tfdst="terraform destroy"
    alias tffmt="terraform fmt -recursive -diff -no-color"
    alias tfini="terraform init"
    alias tfout="terraform output"
    alias tfpn="terraform plan"
    alias tfrfr="terraform refresh"
    alias tfsh="terraform show"
    alias tfst="terraform state"
    alias tfstls="terraform state list"
    alias tfstsh="terraform state show"
    alias tfval="terraform validate"
    alias tfws="terraform workspace"
    alias tfwsls="terraform workspace list"
    alias tfwsse="terraform workspace select"

    # terraform functions
    # todo: add functions
fi
