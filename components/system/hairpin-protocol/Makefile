all:
.PHONY:: all

# ---------------------------------------------------------------------------- #
# hairpin protocol
# ---------------------------------------------------------------------------- #

# @READ and UNDERSTAND
# https://github.com/compumike/hairpin-proxy

install:
	kubectl apply -f https://raw.githubusercontent.com/compumike/hairpin-proxy/v0.2.1/deploy.yml

uninstall:
	kubectl delete -f https://raw.githubusercontent.com/compumike/hairpin-proxy/v0.2.1/deploy.yml

# ---------------------------------------------------------------------------- #
# Global configuration
# ---------------------------------------------------------------------------- #

.ONESHELL:
.SILENT:

SHELL 		:= /bin/bash
INIT_STEP := $(shell source ./../../../environment.txt)

export KUBECONFIG = ./../../../kubeconfig
