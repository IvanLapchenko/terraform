resource "kubernetes_service" "harbor_portal" {
  depends_on = [
    kubernetes_deployment.harbor_portal
  ]
  metadata {
    name      = "harbor-portal"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  spec {
    port {
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "harbor"
    }
  }
}

