# ---------------------------------------------------------------------------- #
# alterconso
# ---------------------------------------------------------------------------- #

## Install alterconso web application
install:
	@[ "${AES_KEY}" ] || echo "AES key should be set in your environment for encryption"
	@[ "${AES_KEY}" ] && \
	helm upgrade --install \
		--set aesKey="${AES_KEY}" \
		--set app.configuration.webapp.vhost=alterconso.leportail.org \
		--set app.containers.webapp.image.repository=rg.fr-par.scw.cloud/le-portail/alterconso/webapp \
		--set app.containers.webapp.image.tag=0.2.8 \
		--set app.containers.mailer.image.repository=rg.fr-par.scw.cloud/le-portail/alterconso/mailer \
		--set app.containers.mailer.image.tag=0.1.2 \
		--set app.ingress.hosts[0].host=alterconso-le-portail.happynuts.me \
		--set app.ingress.hosts[0].paths[0].path=/ \
		--set app.ingress.hosts[0].paths[0].pathType=Prefix \
		--set app.ingress.tls[0].hosts[0]=alterconso-le-portail.happynuts.me \
		--set app.ingress.tls[0].secretName=alterconso-le-portail.happynuts.me-tls \
		--set app.ingress.hosts[1].host=alterconso.leportail.org \
		--set app.ingress.hosts[1].paths[0].path=/ \
		--set app.ingress.hosts[1].paths[0].pathType=Prefix \
		--set app.ingress.tls[1].hosts[0]=alterconso.leportail.org \
		--set app.ingress.tls[1].secretName=alterconso.leportail.org-tls \
		alterconso ../helm-alterconso

## Remove alterconso web application
uninstall:
	@helm uninstall alterconso

## Display alterconso webapp logs with follow option
logs:
	@kubectl logs -f -l app.kubernetes.io/name=alterconso -c webapp

## Dumps a database backup in ./database-dumps/alterconso/${SQL_FILE} directory
database-backup:
	@kubectl exec $(shell kubectl get pods -l app=alterconso-mysql -o name) -- mysqldump --no-tablespaces -u docker -pdocker db > database-dumps/alterconso/${SQL_FILE}

## Restore database from ./database-dumps/alterconso/${SQL_FILE} directory
database-restore:
	@kubectl exec -it $(shell kubectl get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < database-dumps/alterconso/${SQL_FILE}

# ---------------------------------------------------------------------------- #
# Global configuration
# ---------------------------------------------------------------------------- #

.ONESHELL:
.SILENT:

SHELL 						:= /bin/bash
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
	@printf " make alterconso install\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-17s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
