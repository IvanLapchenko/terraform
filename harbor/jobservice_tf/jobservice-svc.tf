resource "kubernetes_service" "harbor_jobservice" {
  depends_on = [
    kubernetes_deployment.harbor_jobservice
  ]
  metadata {
    name      = "harbor-jobservice"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  spec {
    port {
      name        = "http-jobservice"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "harbor"
    }
  }
}

