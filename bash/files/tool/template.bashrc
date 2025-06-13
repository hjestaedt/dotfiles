#!/usr/bin/env bash

if command -v <command> >/dev/null 2>&1; then
    
    # <command> cli aliases

	alias foo='bar'	

    # <command> cli functions
	
	# bar - does foobar things 
    #
	# description:
    #   describe bar
    # 
	# arguments:
    #   foo - describe argument
    # 
	# usage:
    #   bar <foo>
    #   e.g.: bar "foo"
	#
	bar() {
		[ -n "$1" ] || { echo "foo argument required" >&2; return 1; }
		# todo implement
	}

fi
