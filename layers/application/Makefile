# ---------------------------------------------------------------------------- #
# alterconso
# ---------------------------------------------------------------------------- #

## Display alterconso webapp logs with follow option
logs:
	@kubectl logs -f -l app.kubernetes.io/name=alterconso -c webapp

## Dumps a database backup in ./database-dumps/alterconso/${SQL_FILE} directory
database-backup:
	@kubectl exec $(shell kubectl get pods -l app=alterconso-mysql -o name) -- mysqldump --no-tablespaces -u docker -pdocker db --ignore-table=db.Session > ./../../data/alterconso/alterconso-backup-$$(date +%d-%m-%Y-%Hh%M).sql

## Restore database from ./database-dumps/alterconso/${SQL_FILE} directory
database-restore:
	@kubectl exec -it $(shell kubectl get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < database-dumps/alterconso/${SQL_FILE:-}

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
