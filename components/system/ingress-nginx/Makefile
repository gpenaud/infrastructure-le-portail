all:
.PHONY:: all

# ---------------------------------------------------------------------------- #
# Ingress nginx for Scaleway
# ---------------------------------------------------------------------------- #

install:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/scw/deploy.yaml

uninstall:
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/scw/deploy.yaml

# ---------------------------------------------------------------------------- #
# Global configuration
# ---------------------------------------------------------------------------- #

.ONESHELL:
.SILENT:

SHELL 		:= /bin/bash
INIT_STEP := $(shell source ./../../../environment.txt)

export KUBECONFIG = ./../../../kubeconfig
