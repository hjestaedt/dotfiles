#!/usr/bin/env bash

if command -v yq >/dev/null 2>&1; then
    
    # yq cli aliases
	# TODO add aliases

    # yq cli functions
	
	# yqsel - select yaml using yq with field conditions
	#
	# description:
	#   filters yaml input using the select() function with a given condition expression
	#
	# arguments:
	#   condition - yq expression for condition 
	#
	# usage:
	#   yqsel <condition>
	#   e.g.: yqsel '.kind == "Deployment"'
	#   e.g.: yqsel '.metadata.name == "my-app"'
	#   e.g.: yqsel '.spec.replicas > 1'
	#
	yqsel() {
		local condition

		condition="$1"

        [ -n "$condition" ] || { echo "condition argument required" >&2; return 1; }

		yq eval "select(${condition})"
	}

fi
