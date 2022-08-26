#
# global variables
# ----------------

variable project_id {
  type        = string
  description = "Project ID for le-portail infrastructure"
  # test project
  default     = "b2c4f829-56fe-4c2f-95be-1b7d089cc399"
  # le-portail project
  // default     = "341d39c7-1613-45d9-8b9f-e3c001c46cb0"
}

variable force_helm_upgrade {
  type        = bool
  description = "wether or not force helm release to be upgraded"
  default     = "false"
}

variable domain {
  type        = string
  description = "the dns domain used by ingress hostnames"
  default     = "leportail.org"
}

variable deploy_monitoring_stack {
  type        = bool
  description = "Determine wether or not we should deploy the monitoring stack (prometheus & grafana & loki)"
  default     = "true"
}

variable certificate_issuer {
  type        = string
  description = "Set the correct certificate issuer for ingress cert-manager"
  default     = "letsencrypt-staging-clusterissuer" // for production certificate: "letsencrypt-production-clusterissuer"
}

#
# grafana specific variables
# --------------------------

variable grafana_ingress_hostname {
  type        = string
  description = "ingress hostname used by grafana server"
  default     = "test-monitoring"
}

#
# prometheus specific variables
# -----------------------------

variable prometheus_server_ingress_hostname {
  type        = string
  description = "ingress hostname used by prometheus server"
  default     = "test-monitoring-prometheus"
}

variable prometheus_alertmanager_ingress_hostname {
  type        = string
  description = "ingress hostname used by prometheus alertmanager"
  default     = "test-monitoring-alertmanager"
}
