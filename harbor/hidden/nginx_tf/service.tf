resource "kubernetes_service" "harbor" {
  metadata {
    name = "harbor"

    labels = {
      app = "harbor"
    }
  }

  spec {
    port {
      name        = "http"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "harbor"

      component = "nginx"

      release = "release-name"
    }

    type = "LoadBalancer"
  }
}

