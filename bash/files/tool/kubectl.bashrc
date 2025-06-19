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

    alias kbgtstts='kubectl get statefulset'
    alias kbdsstts='kubectl describe statefulset'
    alias kbdlstts='kubectl delete statefulset'

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

	# kbrsccp - copy a kubernetes resource from one namespace to another
	#
	# description:
	#   copies a Kubernetes resource from a source namespace to a target namespace.
	#   automatically removes metadata fields that prevent recreation (resourceVersion,
	#   uid, status) and updates the namespace field.
	#
	# arguments:
	#   resource-kind - type of Kubernetes resource (e.g., deployment, service, configmap)
	#   resource-name - name of the resource to copy
	#   src-namespace - source namespace where the resource currently exists
	#   target-namespace - target namespace where the resource will be copied
	#
	# usage:
	#   kbrscp <resource-kind> <resource-name> <src-namespace> <target-namespace>
	#   e.g.: kbrscp deployment my-app production staging
	#   e.g.: kbrscp service api-service default test
	#   e.g.: kbrscp copy configmap app-config prod dev
	#
	kbrsccp() {
   		local resource_kind resource_name src_namespace target_namespace
   
   		resource_kind="$1"
   		resource_name="$2"
   		src_namespace="$3"
   		target_namespace="$4"
   
   		if [ -z "$resource_kind" ] || [ -z "$resource_name" ] || [ -z "$src_namespace" ] || [ -z "$target_namespace" ]; then
       		echo "usage: kcopy <resource-kind> <resource-name> <src-namespace> <target-namespace>" >&2
       		return 1
   		fi
		
		if kubectl get "$resource_kind" "$resource_name" -n "$target_namespace" >/dev/null 2>&1; then
        	echo "warning: $resource_kind '$resource_name' already exists in namespace '$target_namespace'" >&2
        	read -p "continue? (y/N): " -n 1 -r
        	echo
        	[[ ! $REPLY =~ ^[Yy]$ ]] && return 1
    	fi
   
   		kubectl get "$resource_kind" "$resource_name" -n "$src_namespace" -o yaml | \
       	yq eval ".metadata.namespace = \"$target_namespace\" | del(.metadata.resourceVersion) | del(.metadata.uid) | del(.status)" | \
       	kubectl apply -f -
	}


    # kbessyn - for synchronization of an ExternalSecret resource
    #
    # description:
    #   forces the synchronization of an ExternalSecret resource with the secret management system
    #
    # arguments:
    #   external-secret-name - name of the ExternalSecret ressource
    #
    # usage:
    #   kbessyn <external-secret-name> 
	#
	kbessyn() {
		[ -n "$1" ] || { echo "ExternalSecret name argument required" >&2; return 1; }
		local external_secret_name="$1"

		kubectl annotate es $external_secret_name force-sync=$(date +%s) --overwrite
	}

fi
