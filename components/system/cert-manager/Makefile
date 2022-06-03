all:
.PHONY:: all

# ---------------------------------------------------------------------------- #
# cert-manager
# ---------------------------------------------------------------------------- #

install:
	helm upgrade --namespace kube-system --install cert-manager jetstack/cert-manager \
		--set installCRDs=true \
		--set ingressShim.extraArgs='{--default-issuer-name=letsencrypt-staging-clusterissuer,--default-issuer-kind=ClusterIssuer}'
	kubectl apply -f kubernetes/plain-resources/cert-clusterissuers

uninstall:
	helm uninstall --namespace kube-system cert-manager
	kubectl delete -f kubernetes/plain-resources/cert-clusterissuers

# ---------------------------------------------------------------------------- #
# Global configuration
# ---------------------------------------------------------------------------- #

.ONESHELL:
.SILENT:

SHELL 		:= /bin/bash
INIT_STEP := $(shell source ./../../../environment.txt)

export KUBECONFIG = ./../../../kubeconfig
