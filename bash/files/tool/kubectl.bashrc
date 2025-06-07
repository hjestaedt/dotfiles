#!/usr/bin/env bash

if command -v kubecolor >/dev/null 2>&1; then
	alias kubectl='kubecolor'
fi

if command -v kubectl >/dev/null 2>&1; then

    # bash completion
    # shellcheck disable=SC1090
    source <(kubectl completion bash)

    # kubectl aliases

    alias kbc='kubectl'
    alias kbcap='kubectl apply'
    alias kbcapf='kubectl apply -f'
    alias kbcapk='kubectl apply -k'
    alias kbccfg='kubectl config'
    alias kbccr='kubectl create'
    alias kbcdl='kubectl delete'
    alias kbcdlf='kubectl delete -f'
    alias kbcdlk='kubectl delete -k'
    alias kbcds='kubectl describe'
    alias kbcex='kubectl exec'
    alias kbcexit='kubectl exec -it'
    alias kbcgt='kubectl get'
    alias kbckz='kubectl kustomize'
    alias kbclg='kubectl logs'
    alias kbclgf='kubectl logs -f'
    alias kbcpf='kubectl port-forward'

    alias kbcdla='kubectl delete all --all'
    alias kbcgta='kubectl get all'
    alias kbcgtar='kubectl get all,cm,secret,ing'

    alias kbcgtevt='kubectl get events --sort-by=.metadata.creationTimestamp'
    alias kbcgtevtw='kubectl get events --sort-by=.metadata.creationTimestamp --watch'

    alias kbcgtpo='kubectl get pod'
    alias kbcdspo='kubectl describe pod'
    alias kbcdlpo='kubectl delete pod'
    alias kbctoppo='kubectl top pod'
    alias wkbcgtpo='watch -n 1 kubectl get pod'

    alias kbcgtdp='kubectl get deployment'
    alias kbcdsdp='kubectl describe deployment'
    alias kbcdldp='kubectl delete deployment'

    alias kbcgtsts='kubectl get statefulset'
    alias kbcdssts='kubectl describe statefulset'
    alias kbcdlsts='kubectl delete statefulset'

    alias kbcgtsvc='kubectl get service'
    alias kbcdssvc='kubectl describe service'
    alias kbcdlsvc='kubectl delete service'

    alias kbcgting='kubectl get ingress'
    alias kbcdsing='kubectl describe ingress'
    alias kbcdling='kubectl delete ingress'

    alias kbcgtsc='kubectl get secret'
    alias kbcdssc='kubectl describe secret'
    alias kbcdlsc='kubectl delete secret'

    alias kbcgtexsc='kubectl get externalsecret'
    alias kbcdsexsc='kubectl describe externalsecret'
    alias kbcdlexsc='kubectl delete externalsecret'

    alias kbcgtcm='kubectl get configmap'
    alias kbcdscm='kubectl describe configmap'
    alias kbcdlcm='kubectl delete configmap'

    alias kbcgtpvc='kubectl get pvc'
    alias kbcdspvc='kubectl describe pvc'
    alias kbcdlpvc='kubectl delete pvc'

    alias kbcgtns='kubectl get namespace'
    alias kbccrns='kubectl create namespace'
    alias kbcdsns='kubectl describe namespace'
    alias kbcdlns='kubectl delete namespace'

    alias kbcgtno='kubectl get node'
    alias kbcdsno='kubectl describe node'
    alias kbcdlno='kubectl delete node'
    alias kbctopno='kubectl top node'

    alias kbcgtctx='kubectl config current-context'
    alias kbcgtctxs='kubectl config get-contexts'
    alias kbcsctx='kubectl config use-context'

    alias kbcgtdns="kubectl config view --minify --output 'jsonpath={..namespace}'"
    alias kbcsdns='kubectl config set-context --current --namespace'
    alias kbcdxdns='kubectl config set-context --current --namespace default'

    alias kbcrrr="kubectl rollout restart deployment"

    alias kbcgtpf="ps -ef | grep 'kubectl' | grep 'port-forward' | awk '{print \$(NF-1), \$NF}'"
    alias kbcdxpfa='pgrep -fi "kubectl.*port-forward" | xargs kill -9'

    # kubectl functions

    # description:
    #   show logs of the running pod that matches the pattern
    # arguments:
    #   pattern - pod name pattern
    # usage:
    #   kctl_log <pattern>
    #   e.g.: kctl_log foo
    kctl_log() {
        if [ -z "$1" ]; then
            echo "pod name pattern argument required" 1>&2;
            return 1
        fi
        local pattern="$1"
        shift
        kubectl logs -f "$(kubectl get pods | tail -n +2 | grep -i running | awk '{print $pattern}' | grep "$pattern")" "$@"
    }

    # description:
    #   show logs of the running pod that matches the pattern, in json format
    # arguments:
    #   pattern - pod name pattern
    # usage:
    #   kctl_log_json <pattern>
    #   e.g.: kctl_log_json foo
    kctl_log_json() {
        if [ -z "$1" ]; then
            echo "pod name pattern argument required" 1>&2
            return 1
        fi
        pattern="$1"
        shift
        kubectl logs -f "$(kubectl get pods | tail -n +2 | grep -i running | awk '{print $pattern}' | grep "$pattern")" "$@" | grep '^{.*}$' | jq -r '.'
    }

    # description:
    #   login to the running pod that matches the pattern
    # arguments:
    #   pattern - pod name pattern
    # usage:
    #   kctl_login <pattern>
    #   e.g.: kctl_login foo
    kctl_login() {
        if [ -z "$1" ]; then
            echo "pod name pattern argument required" 1>&2;
            return 1
        fi
        kubectl exec -it "$(kubectl get pods | tail -n +2 | grep -i running | awk '{print $1}' | grep "$1")" -- /bin/bash
    }

    # description:
    #   execute command in the running pod that matches the pattern
    # arguments:
    #   pattern - pod name pattern
    # usage:
    #   kctl_exec <pattern> <command>
    #   e.g.: kctl_exec foo ls -la
    kctl_exec() {
        if [ -z "$1" ]; then
            echo "pod name pattern argument required" 1>&2;
            return 1
        fi
        local pattern="$1"
        shift
        kubectl exec -it "$(kubectl get pods | tail -n +2 | grep -i running | awk '{print $1}' | grep "$pattern")" -- "$@"
    }

    # delete all pods (optional: that match the pattern) with status different than running
    # arguments:
    #   optional: pattern - pod name pattern
    # usage:
    #  kube_cleanup_pods [pattern]
    #  e.g.: kube_cleanup_pods
    kctl_cleanup_pods() {
        if [ -n "$1" ]; then
            for p in $(kubectl get pods | tail -n +2 | grep -vi running | awk '{print $1}' | grep "$1" ); do
                kubectl delete pod --grace-period=0 "$p"
            done
        else
            for p in $(kubectl get pods | tail -n +2 | grep -vi running | awk '{print $1}'); do
                kubectl delete pod --grace-period=0 "$p"
            done
        fi
    }

    # set up port-forwarding for service that matches the pattern (in a loop, to reconnect after timeout)
    # arguments:
    #   pattern - service name pattern
    #   port-mapping - port mapping in the form [<local-port>:]<remote-port>
    # usage:
    #   kube_port_forward <pattern> <port-mapping>
    #   e.g.: kube_port_forward foo-service 8080:80
    kctl_port_forward() {
        if [ -z "$1" ]; then
            echo "service name pattern argument required" 1>&2
            return 1
        fi
        if [ -z "$2" ]; then
            echo "port-mapping argument required" 1>&2
            return 1
        fi

        service="$(kubectl get service | tail -n +2 | awk '{print $1}' | grep "$1")"

        if [ -z "$service" ]; then
            echo "no service matched the pattern" 1>&2
            return 1
        fi
        if [ "$(echo "$service" | wc -l)" -gt 1 ]; then
            echo "more than one service matched the pattern" 1>&2
            return 1
        fi

        while true; do kubectl port-forward svc/"$service" "$2"; done
    }

    # decode secrets that match the pattern
    # arguments:
    #   pattern - secret name pattern
    # usage:
    #   kctl_decode_secret <pattern>
    #   e.g.: kctl_decode_secret foo
    kctl_decode_secret() {
        if [ -z "$1" ]; then
            echo "secret name pattern argument required" 1>&2
            return 1
        fi
        secrets="$(kubectl get secret | tail -n +2 | awk '{print $1}' | grep "$1")"
        for s in $secrets; do
            echo "secret: $s"
            kubectl get secret "$s" -o jsonpath='{.data}' | jq -r '. | map_values(@base64d)'
            echo
        done
    }
fi
