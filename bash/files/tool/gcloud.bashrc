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
	alias gclcfgls='gcloud config list'
	alias gclcfgst='gcloud config set'
	alias gclcfgust='gcloud config unset'
	alias gclcfggt='gcloud config gt'

    alias gclcfgcf='gcloud config configurations'
    alias gclcfglsa='gcloud config configurations list'
    alias gclcfgac='gcloud config configurations activate'
    alias gclcfgcr='gcloud config configurations create'
    alias gclcfgds='gcloud config configurations describe'
    alias gclcfgdl='gcloud config configurations delete'

	# gcloud components
	# https://cloud.google.com/sdk/gcloud/reference/components
	alias gclcmpls='gcloud components list'
	alias gclcmpupd='gcloud components update'
	alias gclcmpist='gcloud components install'
	alias gclcmprm='gcloud components remove'
	alias gclcmprist='gcloud components reinstall'
	
	# gcloud compute
	# https://cloud.google.com/sdk/gcloud/reference/compute
	alias gclco='gcloud compute'

    # gcloud functions
    # TODO: add functions
fi
