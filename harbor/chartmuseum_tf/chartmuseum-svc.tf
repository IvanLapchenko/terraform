resource "kubernetes_service" "harbor_chartmuseum" {
  depends_on = [
    kubernetes_deployment.harbor_chartmuseum
  ]
  metadata {
    name      = "harbor-chartmuseum"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  spec {
    port {
      port        = 80
      target_port = "9999"
    }

    selector = {
      app = "harbor"
    }
  }
}

