# ---------------------------------------------------------------------------- #
# cagette
# ---------------------------------------------------------------------------- #

## Install cagette web application
install:
	@[ "${AES_KEY}" ] || echo "AES key should be set in your environment for encryption"
	@[ "${AES_KEY}" ] && \
	helm upgrade --install \
		--set aesKey="${AES_KEY}" \
		--set app.configuration.webapp.vhost=cagette.leportail.org \
		--set app.containers.webapp.image.repository=rg.fr-par.scw.cloud/le-portail/cagette/webapp \
		--set app.containers.webapp.image.tag=0.2.8 \
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

## Remove cagette web application
uninstall:
	@helm uninstall cagette

## Display cagette webapp logs with follow option
logs:
	@kubectl logs -f -l app.kubernetes.io/name=cagette -c webapp

## Dumps a database backup in ./database-dumps/alterconso/${SQL_FILE} directory
database-backup:
	@kubectl exec $(shell kubectl get pods -l app=cagette-mysql -o name) -- mysqldump --no-tablespaces -u docker -pdocker db > database-dumps/alterconso/${SQL_FILE}

## Restore database from ./database-dumps/alterconso/${SQL_FILE} directory
database-restore:
	@kubectl exec -it $(shell kubectl get pods -l app=cagette-mysql -o name) -- mysql -u docker -pdocker db < database-dumps/alterconso/${SQL_FILE}

## Do nothing at all
all:
.PHONY:: all

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

## display this help text
help:
	@printf "\n"
	@printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	@printf " make cagette install\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-17s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
