#!/usr/bin/env bash

if command -v gcloud >/dev/null 2>&1; then
    # gcloud aliases
    alias gcl="gcloud"
    alias gclcfg="gcloud config"
    alias gclcfgcf="gcloud config configurations"
    alias gclcfgcfac="gcloud config configurations activate"
    alias gclcfgcfds="gcloud config configurations describe"
    alias gclcfgcfls="gcloud config configurations list"

    # gcloud functions
    # todo: add functions
fi
