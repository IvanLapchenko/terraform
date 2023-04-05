resource "kubernetes_service" "redis_operator" {
  depends_on = [
    kubernetes_namespace.redis
  ]
  metadata {
    name      = "redis-operator"
    namespace = var.namespace
    labels = {
      "app"     = "redis-operator"
      "release" = "redis"
    }
  }

  spec {
    port {
      name     = "metrics"
      protocol = "TCP"
      port     = 9710
    }

    selector = {
      "app"     = "redis-operator"
      "release" = "redis"
    }

    type = "ClusterIP"
  }
}

