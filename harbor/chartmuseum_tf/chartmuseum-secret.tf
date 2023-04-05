resource "kubernetes_secret" "harbor_chartmuseum" {
  metadata {
    name      = "harbor-chartmuseum"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    CACHE_REDIS_PASSWORD = var.redis-password
  }

  type = "Opaque"
}

