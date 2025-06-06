#!/usr/bin/env bash

# gcloud

if command -v gcloud >/dev/null 2>&1; then
    # gcloud aliases
    alias gc="gcloud"
    alias gccfg="gcloud config"
    alias gccfgl="gcloud config configurations list"
    alias gccfga="gcloud config configurations activate"
    alias gccfgd="gcloud config configurations describe"
    alias gccfgc="gcloud config configurations create"
    alias gcct="gcloud container"
    alias gcctc="gcloud container clusters"
    alias gcctcl="gcloud container clusters list"
    alias gcctcg="gcloud container clusters get-credentials"

    # gcloud functions
    # todo: add functions
fi
