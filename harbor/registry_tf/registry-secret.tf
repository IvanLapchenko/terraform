resource "kubernetes_secret" "harbor_registry" {
  metadata {
    name      = "harbor-registry"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    REGISTRY_HTTP_SECRET = "WZP6bnqbw5q8HtXN"

    REGISTRY_REDIS_PASSWORD = var.redis-password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "harbor_registry_htpasswd" {
  metadata {
    name = "harbor-registry-htpasswd"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    REGISTRY_HTPASSWD = "harbor_registry_user:$2a$10$cxnAiewaiv7PvihLt507berAWctXrviMjGKdRQKDO1xEMGkqUC5wW"
  }

  type = "Opaque"
}

