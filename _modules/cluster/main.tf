
resource "scaleway_k8s_cluster" "infrastructure" {
  name    = "infrastructure"
  version = "1.23.4"
  cni     = "weave"
}

resource "scaleway_k8s_pool" "default" {
  cluster_id = scaleway_k8s_cluster.infrastructure.id
  name       = "default"
  node_type  = "DEV1-M"
  size       = 1
}

# SMTP ports: 25, 465, 587
resource "scaleway_instance_security_group" "mail" {
  inbound_default_policy  = "drop"
  inbound_rule {
    action = "accept"
    port   = 25
  }

  inbound_rule {
    action = "accept"
    port   = 465
  }

  inbound_rule {
    action = "accept"
    port   = 587
  }

  # @TODO test if outbound is necessary
  outbound_default_policy = "drop"
  outbound_rule {
    action = "accept"
    port   = 25
  }

  outbound_rule {
    action = "accept"
    port   = 465
  }

  outbound_rule {
    action = "accept"
    port   = 587
  }
}

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.default]
  triggers = {
    host                   = scaleway_k8s_cluster.infrastructure.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.infrastructure.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.infrastructure.kubeconfig[0].cluster_ca_certificate
  }
}

resource "local_file" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.default]
  content    = scaleway_k8s_cluster.infrastructure.kubeconfig[0].config_file
  filename   = "${var.root_path}/${var.environment}/kubeconfig"
}

resource "scaleway_lb_ip" "nginx_ip" {
  zone       = "fr-par-1"
  project_id = scaleway_k8s_cluster.infrastructure.project_id
}

output "cluster_url" {
  value = scaleway_k8s_cluster.infrastructure.apiserver_url
}

output "lb_nginx_ip" {
  value = scaleway_lb_ip.nginx_ip
}
