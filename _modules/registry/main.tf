
resource "scaleway_registry_namespace" "registry" {
  count       = var.registry_create ? 1 : 0
  name        = var.registry_name
  description = "${var.registry_name} container registry"
  is_public   = var.registry_is_public
}
