all:
.PHONY:: all

# ---------------------------------------------------------------------------- #
# external-dns (scaleway-compatible)
# ---------------------------------------------------------------------------- #

install: install-external-dns install-scaleway-webhook
uninstall: uninstall-scaleway-webhook uninstall-external-dns

install-scaleway-webhook:
	git clone https://github.com/scaleway/cert-manager-webhook-scaleway.git
	helm install --namespace=cert-manager scaleway-webhook cert-manager-webhook-scaleway/deploy/scaleway-webhook
	rm -rf cert-manager-webhook-scaleway

uninstall-scaleway-webhook:
	helm uninstall --namespace=cert-manager scaleway-webhook

install-external-dns:
	kubectl apply -f plain-resources

uninstall-external-dns:
	kubectl delete -f plain-resources

# ---------------------------------------------------------------------------- #
# Global configuration
# ---------------------------------------------------------------------------- #

.ONESHELL:
.SILENT:

SHELL 		:= /bin/bash
INIT_STEP := $(shell source ./../../../environment.txt)

export KUBECONFIG = ./../../../kubeconfig
