resource "kubernetes_service" "harbor_registry" {
  metadata {
    name      = "harbor-registry"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  spec {
    port {
      name = "http-registry"
      port = 5000
    }

    port {
      name = "http-controller"
      port = 8080
    }

    selector = {
      app = "harbor"
    }
  }
}

