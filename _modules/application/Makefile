# ---------------------------------------------------------------------------- #
# alterconso
# ---------------------------------------------------------------------------- #

KUBECONFIG_DEVELOPMENT := ./../../development/kubeconfig
KUBECONFIG_PRODUCTION  := ./../../production/kubeconfig

## Display alterconso webapp logs with follow option
log-webapp:
	@kubectl --kubeconfig=../../kubeconfig logs -f -l app.kubernetes.io/name=alterconso -c webapp

log-mailer:
	@kubectl --kubeconfig=../../kubeconfig logs -f -l app.kubernetes.io/name=alterconso -c mailer

## Dumps a database backup in ./database-dumps/alterconso/${SQL_FILE} directory
database-backup:
	@kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} exec $(shell kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} get pods -l app=alterconso-mysql -o name) -- mysqldump --no-tablespaces -u docker -pdocker db --ignore-table={db.Session,db.File} > database-dumps/main.sql
	@kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} exec $(shell kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} get pods -l app=alterconso-mysql -o name) -- mysqldump --hex-blob --max_allowed_packet=1G --no-tablespaces -u docker -pdocker db File > dump.sql > database-dumps/files.sql

SQL_DEVELOPMENT := backup-21-09-2022-without-file-constraints.sql
database-development-restore:
	@kubectl --kubeconfig=${KUBECONFIG_DEVELOPMENT} exec -it $(shell kubectl --kubeconfig=${KUBECONFIG_DEVELOPMENT} get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < database-dumps/${SQL_DEVELOPMENT}
database-development-restore-products-images:
	@kubectl --kubeconfig=${KUBECONFIG_DEVELOPMENT} exec -it $(shell kubectl --kubeconfig=${KUBECONFIG_DEVELOPMENT} get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < database-dumps/product-images-only.sql

SQL_PRODUCTION := backup-21-09-2022-without-file-constraints.sql
database-production-restore:
	@kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} exec -it $(shell kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < database-dumps/${SQL_PRODUCTION}
database-production-restore-products-images:
	@kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} exec -it $(shell kubectl --kubeconfig=${KUBECONFIG_PRODUCTION} get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < database-dumps/product-images-only.sql

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
