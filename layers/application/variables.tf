#
# global variables
# ----------------

variable force_helm_upgrade {
  type        = bool
  description = "wether or not force helm release to be upgraded"
  default     = "false"
}

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
