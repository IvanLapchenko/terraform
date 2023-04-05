resource "kubernetes_persistent_volume_claim" "harbor_registry" {
  metadata {
    name      = "harbor-registry"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }

    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

