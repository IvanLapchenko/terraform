resource "kubernetes_secret" "redis" {
  metadata {
    name      = "redis"
    namespace = var.redis_namespace
  }

  data ={
    password =  ""
  }

  type = "Opaque"
}