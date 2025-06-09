#!/usr/bin/env bash

if command -v kubecolor >/dev/null 2>&1; then
	alias kubectl='kubecolor'
fi

if command -v kubectl >/dev/null 2>&1; then

    # bash completion
    # shellcheck disable=SC1090
    source <(kubectl completion bash)

    # kubectl aliases

    alias kb='kubectl'
    alias kbap='kubectl apply'
    alias kbapf='kubectl apply -f'
    alias kbapk='kubectl apply -k'
    alias kbcfg='kubectl config'
    alias kbcr='kubectl create'
    alias kbdl='kubectl delete'
    alias kbdlf='kubectl delete -f'
    alias kbdlk='kubectl delete -k'
    alias kbds='kubectl describe'
    alias kbex='kubectl exec'
    alias kbexit='kubectl exec -it'
    alias kbgt='kubectl get'
    alias kbkz='kubectl kustomize'
    alias kblg='kubectl logs'
    alias kblgf='kubectl logs -f'
    alias kbpf='kubectl port-forward'

    alias kbdla='kubectl delete all --all'
    alias kbgta='kubectl get all'
    alias kbgtar='kubectl get all,cm,secret,ing'

    alias kbgtevt='kubectl get events --sort-by=.metadata.creationTimestamp'
    alias kbgtevtw='kubectl get events --sort-by=.metadata.creationTimestamp --watch'

    alias kbgtpo='kubectl get pod'
    alias kbdspo='kubectl describe pod'
    alias kbdlpo='kubectl delete pod'
    alias kbtoppo='kubectl top pod'
    alias kbgtpow='watch -n 1 kubectl get pod'

    alias kbgtdp='kubectl get deployment'
    alias kbdsdp='kubectl describe deployment'
    alias kbdldp='kubectl delete deployment'

    alias kbgtsts='kubectl get statefulset'
    alias kbdssts='kubectl describe statefulset'
    alias kbdlsts='kubectl delete statefulset'

    alias kbgtsvc='kubectl get service'
    alias kbdssvc='kubectl describe service'
    alias kbdlsvc='kubectl delete service'

    alias kbgting='kubectl get ingress'
    alias kbdsing='kubectl describe ingress'
    alias kbdling='kubectl delete ingress'

    alias kbgtsc='kubectl get secret'
    alias kbdssc='kubectl describe secret'
    alias kbdlsc='kubectl delete secret'

    alias kbgtexsc='kubectl get externalsecret'
    alias kbdsexsc='kubectl describe externalsecret'
    alias kbdlexsc='kubectl delete externalsecret'

    alias kbgtcm='kubectl get configmap'
    alias kbdscm='kubectl describe configmap'
    alias kbdlcm='kubectl delete configmap'

    alias kbgtpvc='kubectl get pvc'
    alias kbdspvc='kubectl describe pvc'
    alias kbdlpvc='kubectl delete pvc'

    alias kbgtns='kubectl get namespace'
    alias kbcrns='kubectl create namespace'
    alias kbdsns='kubectl describe namespace'
    alias kbdlns='kubectl delete namespace'

    alias kbgtno='kubectl get node'
    alias kbdsno='kubectl describe node'
    alias kbdlno='kubectl delete node'
    alias kbtopno='kubectl top node'

    alias kbrrr="kubectl rollout restart deployment"
    alias kbgtpf="ps -ef | grep 'kubectl' | grep 'port-forward' | awk '{print \$(NF-1), \$NF}'"

    # kubectl functions
	#
fi
