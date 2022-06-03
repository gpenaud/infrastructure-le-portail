all:
.PHONY:: all

# ---------------------------------------------------------------------------- #
# website le portail
# ---------------------------------------------------------------------------- #

## Install leportail web site
install:
	@[ "${AES_KEY}" ] || echo "AES key should be set in your environment for encryption"
	@[ "${AES_KEY}" ] && \
	helm upgrade --install \
		--set aesKey="${AES_KEY}" \
		--set app.image.tag=0.0.5 \
		website-le-portail ../helm-website-le-portail

## Remove leportail web site
uninstall:
	helm uninstall website-le-portail

## Dumps a database backup in ./database-dumps/init.sql
database-backup:
	kubectl exec $(shell kubectl get pods -l app=website-le-portail-mysql -o name) -- mysqldump --no-tablespaces -u docker -pdocker leportaivfgam > database-dumps/init.sql

## Restore database from ./database-dumps/init.sql
database-restore:
	kubectl exec -it $(shell kubectl get pods -l app=website-le-portail-mysql -o name) -- mysql -u root -proot < database-dumps/init.sql

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
	@printf " make website-le-portail install\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-17s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
