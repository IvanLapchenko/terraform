resource "kubernetes_persistent_volume_claim" "harbor_jobservice" {
  metadata {
    name      = "harbor-jobservice"
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
        storage = "1Gi"
      }
    }
  }
}

