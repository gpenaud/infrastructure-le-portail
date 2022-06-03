# ---------------------------------------------------------------------------- #
# all
# ---------------------------------------------------------------------------- #

## Install Grafana & Prometheus & Loki
install: install-prometheus install-grafana install-loki

## Remove Grafana & Prometheus & Loki
uninstall: uninstall-prometheus uninstall-grafana uninstall-loki

# ---------------------------------------------------------------------------- #
# prometheus
# ---------------------------------------------------------------------------- #

## Install prometheus, to collect and display infrastructure metrics
install-prometheus:
	helm upgrade --install prometheus helm/prometheus

## Uninstall prometheus
uninstall-prometheus:
	helm uninstall prometheus

# ---------------------------------------------------------------------------- #
# grafana
# ---------------------------------------------------------------------------- #

## Install grafana and its dashboard, a front-end for monitoring
install-grafana:
	@[ "${AES_KEY}" ] || echo "AES key should be set in your environment for encryption"
	@[ "${AES_KEY}" ] && \
	helm upgrade --install \
		--set aesKey="${AES_KEY}" \
	grafana helm/grafana

## Uninstall grafana
uninstall-grafana:
	helm uninstall grafana

# ---------------------------------------------------------------------------- #
# loki
# ---------------------------------------------------------------------------- #

## Install loki, a log broker
install-loki:
	helm install loki helm/loki

## Uninstall loki
uninstall-loki:
	helm uninstall loki

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
	@printf " make monitoring install\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-21s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
