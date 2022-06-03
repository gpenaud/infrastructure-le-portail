all:
.PHONY:: all

# ---------------------------------------------------------------------------- #
# website le portail
# ---------------------------------------------------------------------------- #

install:
	@[ "${AES_KEY}" ] || echo "AES key should be set in your environment for encryption"
	@[ "${AES_KEY}" ] && \
	helm upgrade --install \
		--set aesKey="${AES_KEY}" \
		--set app.image.tag=0.0.5 \
		website-le-portail ../helm-website-le-portail

uninstall:
	helm uninstall website-le-portail

database-backup:
	kubectl exec $(shell kubectl get pods -l app=website-le-portail-mysql -o name) -- mysqldump --no-tablespaces -u docker -pdocker leportaivfgam > database-dumps/init.sql

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
