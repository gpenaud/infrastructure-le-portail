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
		grep -q sops $${file} && echo "[ENCRYPTED] - $${file} is encrypted" || echo "[UNENCRYPTED] - $${file} is not encrypted"
	done

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
