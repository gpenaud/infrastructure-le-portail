#
# global variables
# ----------------

variable project_id {
  type        = string
  description = "Project ID for le-portail infrastructure"
  # projects IDs
  # ------------
  # test:       "b2c4f829-56fe-4c2f-95be-1b7d089cc399"
  # le-portail: "341d39c7-1613-45d9-8b9f-e3c001c46cb0"
}

variable force_helm_upgrade {
  type        = bool
  description = "wether or not force helm release to be upgraded"
}

variable domain {
  type        = string
  description = "the dns domain used by ingress hostnames"
}

variable deploy_monitoring_stack {
  type        = bool
  description = "Determine wether or not we should deploy the monitoring stack (prometheus & grafana & loki)"
}

variable certificate_issuer {
  type        = string
  description = "Set the correct certificate issuer for ingress cert-manager"
}

#
# grafana specific variables
# --------------------------

variable grafana_ingress_hostname {
  type        = string
  description = "ingress hostname used by grafana server"
}

#
# prometheus specific variables
# -----------------------------

variable prometheus_server_ingress_hostname {
  type        = string
  description = "ingress hostname used by prometheus server"
}

variable prometheus_alertmanager_ingress_hostname {
  type        = string
  description = "ingress hostname used by prometheus alertmanager"
}

#
# alterconso specific variables
# -----------------------------

#
# webapp variables
# ----------------

variable webapp_vhost {
  type        = string
  description = "vhost used within webapp application"
}

variable webapp_image_repository {
  type        = string
  description = "the repository used by webapp image"
  default     = "rg.fr-par.scw.cloud/le-portail/alterconso/webapp"
}

variable webapp_image_tag {
  type        = string
  description = "the tag used by webapp image"
}

variable webapp_ingress_host {
  type        = string
  description = "vhost used for ingress on port 80"
}

variable webapp_ingress_tls_host {
  type        = string
  description = "vhost used for ingress on port 443"
}

variable webapp_ingress_tls_secret_name {
  type        = string
  description = "secret used by vhost for ingress on port 443"
  default     = "alterconso.leportail.org-tls"
}

#
# mailer variables
# ----------------

variable mailer_image_repository {
  type        = string
  description = "the repository used by mailer image"
  default     = "rg.fr-par.scw.cloud/le-portail/alterconso/mailer"
}

variable mailer_image_tag {
  type        = string
  description = "the tag used by mailer image"
  default     = "0.1.2"
}
