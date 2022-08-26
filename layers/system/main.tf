terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

data "sops_file" "grafana-operator-resources-secrets" {
  source_file = "${path.root}/helm/monitoring/grafana/operator-resources/secrets.yaml"
}

data "sops_file" "prometheus-operator-resources-secrets" {
  source_file = "${path.root}/helm/monitoring/prometheus/operator-resources/secrets.yaml"
}

#
# cert-manager
# ------------

resource "helm_release" "cert-manager-issuer" {
  name         = "cert-manager-issuer"
  chart        = "${path.root}/helm/cert-manager-issuer"
  force_update = var.force_helm_upgrade

  depends_on = [
    helm_release.cert-manager
  ]
}

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

#
# hairpin-protocol
# ----------------

resource "helm_release" "hairpin-protocol" {
  name         = "hairpin-protocol"
  chart        = "${path.root}/helm/hairpin-protocol"
  force_update = var.force_helm_upgrade
}

# #
# # ingress-nginx
# #
# resource "helm_release" "ingress-nginx" {
#   name         = "ingress-nginx"
#   chart        = "${path.root}/helm/ingress-nginx"
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
    "${file("${path.root}/helm/monitoring/prometheus/values.yaml")}"
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
  chart        = "${path.root}/helm/monitoring/prometheus/operator-resources"
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
    "${file("${path.root}/helm/monitoring/grafana/values.yaml")}"
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
  chart        = "${path.root}/helm/monitoring/grafana/operator-resources"
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
