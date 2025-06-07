#!/usr/bin/env bash

if command -v docker >/dev/null 2>&1; then
    
    # docker aliases
    alias dck='docker'
    alias dckctr='docker container'
    alias dckctx='docker context'
    alias dckex='docker exec'
    alias dckimg='docker image'
    alias dckis='docker inspect'
    alias dcklg='docker logs'
    alias dcknw='docker network'
    alias dckps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"'
    alias dckpsl='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
    alias dckrn='docker run'
    alias dcksys='docker system'
    alias dcksysprna='docker system prune -a'
    alias dckvol='docker volume'

    # docker functions
    # todo: add functions
fi
