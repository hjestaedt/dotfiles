#!/usr/bin/env bash

if command -v skaffold >/dev/null 2>&1; then

    # skaffold aliases

    alias skf="skaffold"
    alias skfbd="skaffold build"
    alias skfbdp="skaffold build --profile"
    alias skfdv="skaffold dev"
    alias skfdvp="skaffold dev --profile"
    alias skfdvpf="skaffold dev --port-forward --profile"
    alias skfrnd="skaffold render"
    alias skfrndp="skaffold render --profile"
    alias skfrn="skaffold run"
    alias skfrnp="skaffold run --profile"
    alias skfrnpf="skaffold run --port-forward --profile"

    # skaffold functions
    # todo: add functions
fi
