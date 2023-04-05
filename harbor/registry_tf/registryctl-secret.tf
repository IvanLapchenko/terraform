resource "kubernetes_secret" "harbor_registryctl" {
  metadata {
    name      = "harbor-registryctl"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  type = "Opaque"
}

