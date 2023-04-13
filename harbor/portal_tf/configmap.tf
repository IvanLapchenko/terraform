resource "kubernetes_config_map" "harbor_portal" {
  metadata {
    name      = "harbor-portal"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    "nginx.conf" = local.jobservice_config
  }
}

