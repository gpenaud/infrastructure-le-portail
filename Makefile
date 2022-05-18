# ---------------------------------------------------------------------------- #
# cluster
# ---------------------------------------------------------------------------- #

up:
	terraform -chdir=terraform apply -auto-approve

down:
	terraform -chdir=terraform destroy -auto-approve

# ---------------------------------------------------------------------------- #
# cagette
# ---------------------------------------------------------------------------- #

install-cagette:
	@[ "${AES_KEY}" ] || echo "AES key should be set in your environment for encryption"
	@[ "${AES_KEY}" ] && \
	helm upgrade --install \
		--set aesKey="${AES_KEY}" \
		--set app.containers.webapp.image.repository=rg.fr-par.scw.cloud/le-portail/cagette/webapp \
		--set app.containers.webapp.image.tag=0.2.3 \
		--set app.containers.mailer.image.repository=rg.fr-par.scw.cloud/le-portail/cagette/mailer \
		--set app.containers.mailer.image.tag=0.1.2 \
		--set app.ingress.hosts[0].host=cagette-le-portail.happynuts.me \
		--set app.ingress.hosts[0].paths[0].path=/ \
		--set app.ingress.hosts[0].paths[0].pathType=Prefix \
		--set app.ingress.tls[0].hosts[0]=cagette-le-portail.happynuts.me \
		--set app.ingress.tls[0].secretName=cagette-le-portail.happynuts.me-tls \
		--set app.ingress.hosts[1].host=cagette.leportail.org \
		--set app.ingress.hosts[1].paths[0].path=/ \
		--set app.ingress.hosts[1].paths[0].pathType=Prefix \
		--set app.ingress.tls[1].hosts[0]=cagette.leportail.org \
		--set app.ingress.tls[1].secretName=cagette.leportail.org-tls \
		cagette ../helm-cagette

uninstall-cagette:
	helm uninstall cagette

cagette-database-backup:
	kubectl exec $(shell kubectl get pods -l app=cagette-mysql -o name) -- mysqldump --no-tablespaces -u docker -pdocker db > /home/gpenaud/work/ecolieu/cagette/docker/mysql/dumps/production.sql

cagette-database-restore:
	kubectl exec -it $(shell kubectl get pods -l app=cagette-mysql -o name) -- mysql -u docker -pdocker db < /home/gpenaud/work/ecolieu/cagette/docker/mysql/dumps/production.sql

# ---------------------------------------------------------------------------- #
# ingress-nginx for scaleway
# ---------------------------------------------------------------------------- #

install-ingress-nginx:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/scw/deploy.yaml

uninstall-ingress-nginx:
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/scw/deploy.yaml

# ---------------------------------------------------------------------------- #
# hairpin protocol
# ---------------------------------------------------------------------------- #

# @READ and UNDERSTAND
# https://github.com/compumike/hairpin-proxy

install-hairpin-protocol:
	kubectl apply -f https://raw.githubusercontent.com/compumike/hairpin-proxy/v0.2.1/deploy.yml

uninstall-hairpin-protocol:
	kubectl delete -f https://raw.githubusercontent.com/compumike/hairpin-proxy/v0.2.1/deploy.yml

# ---------------------------------------------------------------------------- #
# cert-manager
# ---------------------------------------------------------------------------- #

install-certmanager:
	helm upgrade --namespace kube-system --install cert-manager jetstack/cert-manager \
		--set installCRDs=true \
		--set ingressShim.extraArgs='{--default-issuer-name=letsencrypt-issuer,--default-issuer-kind=ClusterIssuer}'

uninstall-certmanager:
	helm uninstall --namespace kube-system cert-manager

install-cert-clusterissuers:
	kubectl apply -f kubernetes/plain-resources/cert-clusterissuers

uninstall-cert-clusterissuers:
	kubectl delete -f kubernetes/plain-resources/cert-clusterissuers

# ---------------------------------------------------------------------------- #
# prometheus
# ---------------------------------------------------------------------------- #

## install prometheus
install-prometheus:
	helm upgrade --install prometheus kubernetes/helm/prometheus

## uninstall prometheus
uninstall-prometheus:
	helm uninstall prometheus

# ---------------------------------------------------------------------------- #
# grafana
# ---------------------------------------------------------------------------- #

## install grafana
install-grafana:
	helm upgrade --install grafana kubernetes/helm/grafana

## uninstall grafana
uninstall-grafana:
	helm uninstall grafana

# ---------------------------------------------------------------------------- #
# loki
# ---------------------------------------------------------------------------- #

## install grafana
install-loki:
	helm install loki kubernetes/helm/loki

## uninstall loki
uninstall-loki:
	helm uninstall loki

# ---------------------------------------------------------------------------- #
# external-dns (scaleway-compatible)
# ---------------------------------------------------------------------------- #

install-scaleway-webhook:
	git clone https://github.com/scaleway/cert-manager-webhook-scaleway.git
	helm install --namespace=cert-manager scaleway-webhook cert-manager-webhook-scaleway/deploy/scaleway-webhook
	rm -rf cert-manager-webhook-scaleway

uninstall-scaleway-webhook:
	helm uninstall --namespace=cert-manager scaleway-webhook

install-external-dns:
	kubectl apply -f kubernetes/external-dns

uninstall-external-dns:
	kubectl delete -f kubernetes/external-dns

# ---------------------------------------------------------------------------- #
# 																																						 #
# ---------------------------------------------------------------------------- #

.ONESHELL:

## permanent variables
PROJECT			?= github.com/gpenaud/k3s-infrastructure
RELEASE			?= $(shell git describe --tags --abbrev=0)
COMMIT			?= $(shell git rev-parse --short HEAD)
BUILD_TIME  ?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')

## Colors
COLOR_RESET       = $(shell tput sgr0)
COLOR_ERROR       = $(shell tput setaf 1)
COLOR_COMMENT     = $(shell tput setaf 3)
COLOR_TITLE_BLOCK = $(shell tput setab 4)

## display this help text
help:
	@printf "\n"
	@printf "${COLOR_TITLE_BLOCK}${PROJECT} Makefile${COLOR_RESET}\n"
	@printf "\n"
	@printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	@printf " make build\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-15s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
