
//
// cert-Mmanager
//
resource "helm_release" "cert-manager-issuer" {
  name       = "cert-manager-issuer"
  chart      = "./helm/cert-manager-issuer"
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "jetstack"
  chart      = "cert-manager"
  version    = "v1.9.1"

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "ingressShim.extraArgs"
		value = "'{--default-issuer-name=letsencrypt-staging-clusterissuer,--default-issuer-kind=ClusterIssuer}'"
  }
}

//
// hairpin-protocol
//
resource "helm_release" "hairpin-protocol" {
  name       = "hairpin-protocol"
  chart      = "./helm/hairpin-protocol"
}

//
// ingress-nginx
//
resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  chart      = "./helm/ingress-nginx"
}

//
// monitoring (grafana & prometheus & loki)
//
resource "helm_release" "grafana" {
  count      = var.deploy_monitoring_stack ? 1 : 0
  name       = "grafana"
  namespace  = "monitoring"
  repository = "bitnami"
  chart      = "grafana-operator"

  values = [
    "${file("./helm/monitoring/grafana/values.yaml")}"
  ]
}

provider "sops" {}

data "sops_file" "grafana-operator-resources-secrets" {
  source_file = "./helm/monitoring/grafana/operator-resources/secrets.yaml"
}

resource "helm_release" "grafana-operator-resources" {
  count      = var.deploy_monitoring_stack ? 1 : 0
  name       = "grafana-operator-resources"
  namespace  = "monitoring"
  chart      = "./helm/monitoring/grafana/operator-resources"

  set {
    name  = "sops_admin_user"
    value = data.sops_file.grafana-operator-resources-secrets.data["admin_user"]
  }

  set {
    name  = "sops_admin_password"
    value = data.sops_file.grafana-operator-resources-secrets.data["admin_password"]
  }
}
