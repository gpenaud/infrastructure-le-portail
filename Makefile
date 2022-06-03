# ---------------------------------------------------------------------------- #
# cluster
# ---------------------------------------------------------------------------- #

## Spawns a scaleway cluster with one node only
up:
	terraform -chdir=terraform apply -auto-approve

## Destroys the scaleway cluster
down:
	terraform -chdir=terraform destroy -auto-approve

# ---------------------------------------------------------------------------- #
# Applications
# ---------------------------------------------------------------------------- #

.PHONY: cagette
## Manage cagette installation
cagette:
	@$(MAKE) -s -C components/applicative/cagette $(COMMAND_ARGS)

.PHONY: website-le-portail
## Manage the website of association "Le Portail"
website-le-portail:
	@$(MAKE) -s -C components/applicative/website-le-portail $(COMMAND_ARGS)

# ---------------------------------------------------------------------------- #
# Infrastructure
# ---------------------------------------------------------------------------- #

.PHONY: ingress-nginx
## Deploys a functionnal nginx ingress for scaleway cluster
ingress-nginx:
	@$(MAKE) -s -C components/system/ingress-nginx $(COMMAND_ARGS)

.PHONY: cert-manager
## Deploys cert-manager, a tool wich generate Let's encrypt certificates with automation
cert-manager:
	@$(MAKE) -s -C components/system/cert-manager $(COMMAND_ARGS)

.PHONY: hairpin-protocol
## Deploys a tool which allows challenge successfullness for cert-manager
hairpin-protocol:
	@$(MAKE) -s -C components/system/hairpin-protocol $(COMMAND_ARGS)

.PHONY: monitoring
## Deploys a whole monitoring stack: grafana & prometheus & loki
monitoring:
	@$(MAKE) -s -C components/system/monitoring $(COMMAND_ARGS)

.PHONY: external-dns
## Deploys a way to do DNS-As-Service - Adds automatically DNS entry by deploying an ingress
external-dns:
	@$(MAKE) -s -C components/system/external-dns $(COMMAND_ARGS)

# ---------------------------------------------------------------------------- #
# 																																						 #
# ---------------------------------------------------------------------------- #

.ONESHELL:
.SILENT:

## permanent variables
PROJECT ?= github.com/gpenaud/infrastructure-le-portail

## Colors
BOLD 							= $(shell tput bold)
UNDERLINE					= $(shell tput smul)
NOT_UNDERLINE			= $(shell tput rmul)
COLOR_RESET				= $(shell tput sgr0)
COLOR_ERROR				= $(shell tput setaf 1)
COLOR_COMMENT			= $(shell tput setaf 3)

COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
# ...and turn them into do-nothing targets
$(eval $(COMMAND_ARGS):;@:)

## display this help text
help:
	@printf "\n"
	@printf "${BOLD}Makefile for project ${UNDERLINE}${PROJECT}${NOT_UNDERLINE}${COLOR_RESET}\n"
	@printf "\n"
	@printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	@printf " make up\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-19s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
