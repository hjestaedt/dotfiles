#!/usr/bin/env bash

if command -v docker-compose >/dev/null 2>&1; then

    # docker-compose aliases
    alias dcp="docker-compose"
    alias dcpbd="docker-compose build"
    alias dcpdn="docker-compose down"
    alias dcpex="docker-compose exec"
    alias dcplg="docker-compose logs"
    alias dcplgf="docker-compose logs -f"
    alias dcppl="docker-compose pull"
    alias dcpps="docker-compose ps"
    alias dcprn="docker-compose run"
    alias dcprsr="docker-compose restart"
    alias dcpstr="docker-compose start"
    alias dcpstp="docker-compose stop"
    alias dcpup="docker-compose up"

    # docker-compose functions
    # todo: add functions
fi
