resource "kubernetes_config_map" "harbor_jobservice" {
  metadata {
    name      = "harbor-jobservice"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    "config.yml" = local.jobservice_config
  }
}

