
data "sops_file" "grafana-operator-resources-secrets" {
  source_file = "${var.root_path}/_helm/monitoring/grafana/operator-resources/secrets.yaml"
}

data "sops_file" "prometheus-operator-resources-secrets" {
  source_file = "${var.root_path}/_helm/monitoring/prometheus/operator-resources/secrets.yaml"
}

data "sops_file" "scw-credentials-secrets" {
  source_file = "${var.root_path}/${var.environment}/scw-credentials.yaml"
}

#
# nginx-ingress
# -------------

resource "helm_release" "nginx_ingress" {
  name      = "nginx-ingress"
  namespace = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.service.loadBalancerIP"
    // value = scaleway_lb_ip.nginx_ip.ip_address
    // value = lb_nginx_ip.ip_address
    value = var.lb_nginx_ip.ip_address
  }

  // enable proxy protocol to get client ip addr instead of loadbalancer one
  set {
    name  = "controller.config.use-proxy-protocol"
    value = "true"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
    value = "true"
  }

  // indicates in which zone to create the loadbalancer
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
    // value = scaleway_lb_ip.nginx_ip.zone
    // value = lb_nginx_ip.zone
    value = var.lb_nginx_ip.zone
  }

  // enable to avoid node forwarding
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
}

#
# cert-manager
# ------------

resource "helm_release" "cert-manager" {
  name         = "cert-manager"
  repository   = "https://charts.jetstack.io"
  chart        = "cert-manager"
  version      = "v1.9.1"
  force_update = var.force_helm_upgrade

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "ingressShim.extraArgs"
		value = "'{--default-issuer-name=letsencrypt-staging-clusterissuer,--default-issuer-kind=ClusterIssuer}'"
  }
}

resource "helm_release" "cert-manager-issuer" {
  name         = "cert-manager-issuer"
  chart        = "${var.root_path}/_helm/cert-manager-issuer"
  force_update = var.force_helm_upgrade

  depends_on = [
    helm_release.cert-manager
  ]
}

#
# external-dns
# ------------

resource "helm_release" "external-dns" {
  count        = var.deploy_external_dns ? 1 : 0
  name         = "external-dns"
  chart        = "${var.root_path}/_helm/external-dns"
  force_update = var.force_helm_upgrade

  set {
    name  = "external_dns_image"
    value = var.external_dns_image
  }

  set {
    name  = "external_dns_source"
    value = var.external_dns_source
  }

  set {
    name  = "external_dns_domain"
    value = var.external_dns_domain
  }

  set {
    name  = "external_dns_access_key"
    value = data.sops_file.scw-credentials-secrets.data["scw_access_key"]
  }

  set {
    name  = "external_dns_secret_key"
    value = data.sops_file.scw-credentials-secrets.data["scw_secret_key"]
  }
}

#
# hairpin-protocol
# ----------------

resource "helm_release" "hairpin-protocol" {
  name         = "hairpin-protocol"
  chart        = "${var.root_path}/_helm/hairpin-protocol"
  force_update = true
}

# #
# # ingress-nginx
# #
# resource "helm_release" "ingress-nginx" {
#   name         = "ingress-nginx"
#   chart        = "${inputs.root_path}/_helm/_helm/ingress-nginx"
#   force_update = var.force_helm_upgrade
# }

#
# monitoring (grafana & prometheus & loki)
# ----------------------------------------

resource "helm_release" "prometheus" {
  count        = var.deploy_monitoring_stack ? 1 : 0
  name         = "prometheus"
  namespace    = "kube-system"
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "kube-prometheus"
  force_update = var.force_helm_upgrade

  values = [
    "${file("${var.root_path}/_helm/monitoring/prometheus/values.yaml")}"
  ]

  set {
    name  = "prometheus.ingress.hostname"
    value = "${var.prometheus_server_ingress_hostname}.${var.domain}"
  }

  set {
    name  = "prometheus.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "${var.certificate_issuer}"
  }

  set {
    name  = "alertmanager.ingress.hostname"
    value = "${var.prometheus_alertmanager_ingress_hostname}.${var.domain}"
  }

  set {
    name  = "alertmanager.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "${var.certificate_issuer}"
  }
}

resource "helm_release" "prometheus-operator-resources" {
  count        = var.deploy_monitoring_stack ? 1 : 0
  name         = "prometheus-operator-resources"
  namespace    = "kube-system"
  chart        = "${var.root_path}/_helm/monitoring/prometheus/operator-resources"
  force_update = var.force_helm_upgrade

  set {
    name  = "alertmanager_smtp_password"
    value = data.sops_file.prometheus-operator-resources-secrets.data["alertmanager_smtp_password"]
  }
}

resource "helm_release" "grafana" {
  count        = var.deploy_monitoring_stack ? 1 : 0
  name         = "grafana"
  namespace    = "kube-system"
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "grafana-operator"
  force_update = var.force_helm_upgrade

  values = [
    "${file("${var.root_path}/_helm/monitoring/grafana/values.yaml")}"
  ]

  set {
    name  = "grafana.ingress.hostname"
    value = "${var.grafana_ingress_hostname}.${var.domain}"
  }

  set {
    name  = "grafana.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "${var.certificate_issuer}"
  }
}

resource "helm_release" "grafana-operator-resources" {
  count        = var.deploy_monitoring_stack ? 1 : 0
  name         = "grafana-operator-resources"
  namespace    = "kube-system"
  chart        = "${var.root_path}/_helm/monitoring/grafana/operator-resources"
  force_update = var.force_helm_upgrade

  set {
    name  = "sops_admin_user"
    value = data.sops_file.grafana-operator-resources-secrets.data["admin_user"]
  }

  set {
    name  = "sops_admin_password"
    value = data.sops_file.grafana-operator-resources-secrets.data["admin_password"]
  }
}
