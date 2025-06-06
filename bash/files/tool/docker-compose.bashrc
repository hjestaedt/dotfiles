#!/usr/bin/env bash

if command -v docker-compose >/dev/null 2>&1; then

    # docker-compose aliases
    alias dc="docker-compose"
    alias dcu="docker-compose up"
    alias dcd="docker-compose down"
    alias dcb="docker-compose build"
    alias dcr="docker-compose run"
    alias dcs="docker-compose start"
    alias dct="docker-compose stop"
    alias dcps="docker-compose ps"
    alias dcl="docker-compose logs"
    alias dclf="docker-compose logs -f"
    alias dcex="docker-compose exec"
    alias dcpl="docker-compose pull"
    alias dcrs="docker-compose restart"

    # docker-compose functions
    # todo: add functions
fi
