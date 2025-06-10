#!/usr/bin/env bash

if command -v gcloud >/dev/null 2>&1; then
    
	# gcloud aliases
    
	alias gcl='gcloud'

	# gcloud auth
	# https://cloud.google.com/sdk/gcloud/reference/auth
	alias gclau='gcloud auth'
	alias gclauls='gcloud auth list'
	alias gclaulgi='gcloud auth login'
	alias gclaurvk='gcloud auth revoke'
	alias gclauadlgi='gcloud auth application-default login'
	alias gclauadrvk='gcloud auth application-default revoke'

	# gcloud config
	# https://cloud.google.com/sdk/gcloud/reference/config
    alias gclcfg='gcloud config'
    alias gclcfgcf='gcloud config configurations'
    alias gclcfgcfls='gcloud config configurations list'
    alias gclcfgcfac='gcloud config configurations activate'
    alias gclcfgcfds='gcloud config configurations describe'

    # gcloud functions
    # TODO: add functions
fi
