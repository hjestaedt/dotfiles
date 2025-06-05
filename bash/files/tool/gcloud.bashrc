#!/usr/bin/env bash

# gcloud

if command -v gcloud >/dev/null 2>&1; then
    # gcloud aliases
    alias gclcfg='gcloud config configurations'
    alias gclcfga='gcloud config configurations activate'
    alias gclcfgd='gcloud config configurations describe'
    alias gclcfgl='gcloud config configurations list'

    # gcloud functions
    # todo: add functions
fi
