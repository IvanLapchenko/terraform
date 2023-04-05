resource "kubernetes_secret" "sa_secret" {
  depends_on = [
    kubernetes_namespace.redis
  ]

  metadata {
    name      = "sa-secret"
    namespace = var.namespace
  }

  data = {
    username = "admin"
    password = "admin"
  }
}