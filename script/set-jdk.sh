#!/bin/bash

##
## Switch between different JDK installations.
##
## The script must be sourced and NOT executed, e.g.:
## source ~/bin/set-jdk.sh 11
##
## It might be a good idea to create an alias for this, e.g.: 
## alias set-jdk="source ~/bin/set-jdk.sh"
## 
## If a valid version is passed, PATH and JAVA_HOME are set accordingly. 
## If no or no valid version is passed, PATH is cleaned up and JAVA_HOME is unset.
## 
## author: holger.jestaedt@pribas.com
## last updated: 21.07.2022
##

usage() { echo "usage: source set-jdk.sh 8|11|17"; return; }

JDK8=$HOME/opt/jdk/jdk8
JDK11=$HOME/opt/jdk/jdk11
JDK17=$HOME/opt/jdk/jdk17

# remove jdk from path 
PATH=$(echo "$PATH" | tr ":" "\n" | grep -vi "jdk" | head -c -1 | tr "\n" ":"); export PATH 
# delete JAVA_HOME
unset JAVA_HOME                                                              i

case "$1" in
    "8") JAVA_HOME=$JDK8;;
    "11") JAVA_HOME=$JDK11;;
    "17") JAVA_HOME=$JDK17;;
    *) usage
esac

if [ -n "$JAVA_HOME" ]; then
  export JAVA_HOME
  export PATH=$JAVA_HOME/bin:$PATH

  java -version 2>&1 | head -n 1
fi
