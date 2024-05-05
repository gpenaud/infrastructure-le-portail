## permanent variables
.ONESHELL:
SHELL 			:= /bin/bash
PROJECT			?= github.com/gpenaud/infrastructure-le-portail
RELEASE			?= $(shell git describe --tags --abbrev=0)
CURRENT_TAG ?= $(shell git describe --exact-match --tags 2> /dev/null)
COMMIT			?= $(shell git rev-parse --short HEAD)
BUILD_TIME  ?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')

## Encrypt sops secret files recursively
encrypt-sops:
	@for file in $(shell find . ! -path "*/.terragrunt-cache/*" -name encrypted.yaml); do
		sops --encrypt $${file} > $${file}.tmp && mv --force $${file}.tmp $${file}
	done

## Decrypt sops secret files recursively
decrypt-sops:
	@for file in $(shell find . ! -path "*/.terragrunt-cache/*" -name encrypted.yaml); do
		sops --decrypt $${file} > $${file}.tmp && mv --force $${file}.tmp $${file}
	done

check-sops:
	@for file in $(shell find . ! -path "*/.terragrunt-cache/*" -name encrypted.yaml); do
		grep -q sops $${file} && echo -e " \U2705 [ENCRYPTED] - $${file} is encrypted" || echo -e " \U274C [UNENCRYPTED] - $${file} is not encrypted"
	done

# SQL_BACKUP_DIRECTORY ?= backup-$(shell date -u '+%d-%m-%Y')
SQL_BACKUP_DIRECTORY ?= backup-04-05-2024

## Dumps a database backup in ./database-dumps/alterconso/${SQL_FILE} directory
database-backup:
	@kubectl --kubeconfig=kubeconfig cp --no-preserve --retries=10 ../common/backup/alterconso-backup.sh default/$(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name | sed 's#.*/##'):backup.sh
	@echo "executing backup.sh script"
	@kubectl --kubeconfig=kubeconfig exec -it $(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name) -- bash backup.sh
	@echo "creating backup directory"
	@mkdir -p application/alterconso/database-dumps/${SQL_BACKUP_DIRECTORY}
	@echo "copying backup file locally"
	@kubectl --kubeconfig=kubeconfig cp --retries=10 default/$(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name | sed 's#.*/##'):backup.sql application/alterconso/database-dumps/${SQL_BACKUP_DIRECTORY}/backup.sql

database-restore:
	# @kubectl --kubeconfig=kubeconfig cp --retries=10 application/alterconso/database-dumps/${SQL_BACKUP_DIRECTORY}/files.sql default/$(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name | sed 's#.*/##'):files.sql
	# @kubectl --kubeconfig=kubeconfig exec -it $(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name) -- bash -c "mysql -u docker -pdocker db < files.sql"
	# @kubectl --kubeconfig=kubeconfig cp --retries=10 application/alterconso/database-dumps/${SQL_BACKUP_DIRECTORY}/main.sql default/$(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name | sed 's#.*/##'):main.sql
	# @kubectl --kubeconfig=kubeconfig exec -it $(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name) -- bash -c "mysql -u docker -pdocker db < main.sql"
	@kubectl --kubeconfig=kubeconfig cp --retries=10 application/alterconso/database-dumps/${SQL_BACKUP_DIRECTORY}/backup.sql default/$(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name | sed 's#.*/##'):backup.sql
	# @kubectl --kubeconfig=kubeconfig exec -it $(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < application/alterconso/database-dumps/${SQL_BACKUP_DIRECTORY}/files.sql
	# @kubectl --kubeconfig=kubeconfig exec -it $(shell kubectl --kubeconfig=kubeconfig get pods -l app=alterconso-mysql -o name) -- mysql -u docker -pdocker db < application/alterconso/database-dumps/${SQL_BACKUP_DIRECTORY}/main.sql

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
	@printf " make encrypt-sops\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-_0-9@]+:/ { \
				helpLine = match(lastLine, /^## (.*)/); \
				helpCommand = substr($$1, 0, index($$1, ":")); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				printf " ${COLOR_INFO}%-15s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
