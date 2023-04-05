resource "kubernetes_service" "harbor_core" {
  depends_on = [
    kubernetes_deployment.harbor_core
  ]
  metadata {
    name      = "harbor-core"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  spec {
    port {
      name        = "http-web"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "harbor"
    }
  }
}

