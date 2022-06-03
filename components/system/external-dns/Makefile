# ---------------------------------------------------------------------------- #
# external-dns (scaleway-compatible)
# ---------------------------------------------------------------------------- #

## Deploys scaleway-webhook and external-dns itself
install: install-external-dns install-scaleway-webhook
## Remove scaleway-webhook and external-dns itself
uninstall: uninstall-scaleway-webhook uninstall-external-dns

## Deploys scaleway-webhook, a tool which allows scaleway to write DNS entry dynamically
install-scaleway-webhook:
	git clone https://github.com/scaleway/cert-manager-webhook-scaleway.git
	helm install --namespace=cert-manager scaleway-webhook cert-manager-webhook-scaleway/deploy/scaleway-webhook
	rm -rf cert-manager-webhook-scaleway

## Remove scaleway-webhook component
uninstall-scaleway-webhook:
	helm uninstall --namespace=cert-manager scaleway-webhook

## Deploys external-dns, which joins ingress with DNS As-a-Service
install-external-dns:
	kubectl apply -f plain-resources

## Remove external-dns component
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

## Colors
COLOR_RESET       = $(shell tput sgr0)
COLOR_ERROR       = $(shell tput setaf 1)
COLOR_COMMENT     = $(shell tput setaf 3)
COLOR_TITLE_BLOCK = $(shell tput setab 4)

## Do nothing at all
all:
.PHONY:: all

## Display this help text
help:
	@printf "\n"
	@printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	@printf " make external-dns install\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-27s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
