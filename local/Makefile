## permanent variables
.ONESHELL:
SHELL 			:= /bin/bash
PROJECT			?= github.com/gpenaud/alterconso-webapp

## Start, then log alterconso stack locally
up:
	docker compose up --detach
	docker compose logs --follow webapp mailer

## Start, then log alterconso stack locally
up-development:
	docker compose -f docker-compose.yml -f docker-compose.development.yml up --build --detach
	docker compose logs --follow webapp mailer

## Start, then log alterconso stack locally, but force build first (without --no-cache option)
up-with-build:
	docker compose up --build --detach
	docker compose logs --follow webapp mailer

## Stop local alterconso stack
down:
	docker compose down --volumes

## Connect within webapp container with /bin/bash
enter:
	docker compose exec --user root webapp bash

## clear images cached
cache-clear:
	docker compose exec --user root --workdir /var/www/alterconso/www webapp sh -c "rm -rf file/"

# ---------------------------------------------------------------------------- #

SQL_BACKUP_DIRECTORY := backup-24-09-2022

## Backups database from its development version
database-restore:
	docker cp database-dumps/${SQL_BACKUP_DIRECTORY}/files.sql $(shell docker compose ps -q mysql):/files.sql
	docker compose exec mysql sh -c "mysql -u docker -pdocker db  < files.sql"
	docker cp database-dumps/${SQL_BACKUP_DIRECTORY}/main.sql $(shell docker compose ps -q mysql):/main.sql
	docker compose exec mysql sh -c "mysql -u docker -pdocker db  < main.sql"

# ---------------------------------------------------------------------------- #

recompile-backend:
	docker compose exec --user root --workdir /var/www/alterconso/backend webapp  sh -c "haxe alterconso.hxml"

recompile-frontend:
	docker compose exec --user root --workdir /var/www/alterconso/frontend webapp sh -c "haxe alterconsoJs.hxml"

test-generic:
	docker compose exec --user root --workdir /var/www/alterconso/www webapp sh -c "neko index.n cron/test"

test-product-import:
	docker compose exec --user root --workdir /var/www/alterconso/www webapp sh -c "neko index.n product/debugimport"

test-distribution-notifications:
	docker compose exec --user root --workdir /var/www/alterconso/www webapp sh -c "neko index.n cron/testDistributionNotifications"

## Install mkcert for self-signed certificates generation
certificates-install-mkcert:
	sudo apt install --yes libnss3-tools
	sudo wget -O /usr/local/bin/mkcert "https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64" && sudo chmod +x /usr/local/bin/mkcert
	mkcert -install

## Generate self-signed certificates
certificates-generate:
	mkcert -cert-file configuration/apache2/certificates/cert.pem -key-file configuration/apache2/certificates/key.pem alterconso.localhost
	chmod 0644 configuration/apache2/certificates/key.pem

## Colors
COLOR_RESET       = $(shell tput sgr0)
COLOR_ERROR       = $(shell tput setaf 1)
COLOR_COMMENT     = $(shell tput setaf 3)
COLOR_TITLE_BLOCK = $(shell tput setab 4)

## Display this help text
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
				printf " ${COLOR_INFO}%-29s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n"
