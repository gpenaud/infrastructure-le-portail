all:
.PHONY:: all

# ---------------------------------------------------------------------------- #
# all
# ---------------------------------------------------------------------------- #

install: install-prometheus install-grafana install-loki
uninstall: uninstall-prometheus uninstall-grafana uninstall-loki

# ---------------------------------------------------------------------------- #
# prometheus
# ---------------------------------------------------------------------------- #

## install prometheus
install-prometheus:
	helm upgrade --install prometheus helm/prometheus

## uninstall prometheus
uninstall-prometheus:
	helm uninstall prometheus

# ---------------------------------------------------------------------------- #
# grafana
# ---------------------------------------------------------------------------- #

## install grafana
install-grafana:
	@[ "${AES_KEY}" ] || echo "AES key should be set in your environment for encryption"
	@[ "${AES_KEY}" ] && \
	helm upgrade --install \
		--set aesKey="${AES_KEY}" \
	grafana helm/grafana

## uninstall grafana
uninstall-grafana:
	helm uninstall grafana

# ---------------------------------------------------------------------------- #
# loki
# ---------------------------------------------------------------------------- #

## install grafana
install-loki:
	helm install loki helm/loki

## uninstall loki
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
