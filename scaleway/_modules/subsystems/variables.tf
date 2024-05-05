#
# global variables
# ----------------

variable root_path {
  type        = string
  description = "the path to the root directory"
}

variable environment {
  type        = string
  description = "current environment"
}

variable force_helm_upgrade {
  type        = bool
  description = "wether or not force helm release to be upgraded"
}

variable domain {
  type        = string
  description = "the dns domain used by ingress hostnames"
}

variable lb_nginx_ip {
  type        = any
  description = "load balancer data from scaleway cluster"
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
# external-dns variables
# ----------------------

variable deploy_external_dns {
  type        = bool
  description = "Determine wether or not we should deploy extrnal-dns"
}

variable external_dns_image {
  type        = string
  description = "Set the correct certificate issuer for ingress cert-manager"
}

variable external_dns_source {
  type        = string
  description = "Object type to bind with external-dns (service or ingress)"
}

variable external_dns_domain {
  type        = string
  description = "The domain available for external-dns to manage"
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
