terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
}

provider "scaleway" {
  zone       = "fr-par-1"
  region     = "fr-par"
  project_id = var.project_id
}

resource "scaleway_k8s_cluster" "alterconso" {
  name    = "alterconso"
  version = "1.23.4"
  cni     = "weave"
}

resource "scaleway_k8s_pool" "default" {
  cluster_id = scaleway_k8s_cluster.alterconso.id
  name       = "default"
  node_type  = "DEV1-M"
  size       = 1
}

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.default]
  triggers = {
    host                   = scaleway_k8s_cluster.alterconso.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.alterconso.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.alterconso.kubeconfig[0].cluster_ca_certificate
  }
}

provider "helm" {
  kubernetes {
    host  = null_resource.kubeconfig.triggers.host
    token = null_resource.kubeconfig.triggers.token
    cluster_ca_certificate = base64decode(
      null_resource.kubeconfig.triggers.cluster_ca_certificate
    )
  }
}

resource "scaleway_lb_ip" "nginx_ip" {
  zone       = "fr-par-1"
  project_id = scaleway_k8s_cluster.alterconso.project_id
}

resource "helm_release" "nginx_ingress" {
  name      = "nginx-ingress"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.service.loadBalancerIP"
    value = scaleway_lb_ip.nginx_ip.ip_address
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
    value = scaleway_lb_ip.nginx_ip.zone
  }

  // enable to avoid node forwarding
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
}

resource "local_file" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.default]
  content    = scaleway_k8s_cluster.alterconso.kubeconfig[0].config_file
  filename   = "${path.module}/kubeconfig"
}

module layer_system {
  source = "./layers/system"

  force_helm_upgrade                       = var.force_helm_upgrade
  domain                                   = var.domain
  deploy_monitoring_stack                  = var.deploy_monitoring_stack
  certificate_issuer                       = var.certificate_issuer
  grafana_ingress_hostname                 = var.grafana_ingress_hostname
  prometheus_server_ingress_hostname       = var.prometheus_server_ingress_hostname
  prometheus_alertmanager_ingress_hostname = var.prometheus_alertmanager_ingress_hostname
}

module layer_application {
  source = "./layers/application"

  webapp_vhost                   = var.webapp_vhost
  webapp_image_repository        = var.webapp_image_repository
  webapp_image_tag               = var.webapp_image_tag
  webapp_ingress_host            = var.webapp_ingress_host
  webapp_ingress_tls_host        = var.webapp_ingress_tls_host
  webapp_ingress_tls_secret_name = var.webapp_ingress_tls_secret_name
  mailer_image_repository        = var.mailer_image_repository
  mailer_image_tag               = var.mailer_image_tag
}

output "cluster_url" {
  value = scaleway_k8s_cluster.alterconso.apiserver_url
}
