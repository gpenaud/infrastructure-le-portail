#
# global variables
# ----------------

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
