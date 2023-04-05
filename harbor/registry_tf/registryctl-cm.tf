resource "kubernetes_config_map" "harbor_registryctl" {
  metadata {
    name      = "harbor-registryctl"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }
}

