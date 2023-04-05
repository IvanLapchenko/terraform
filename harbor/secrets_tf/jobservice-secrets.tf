resource "kubernetes_secret" "harbor_jobservice" {
  depends_on = [
    kubernetes_namespace.harbor_namespace
  ]
  metadata {
    name      = "harbor-jobservice"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    JOBSERVICE_SECRET = "0nTPwd5YN9ZanQEy"

    REGISTRY_CREDENTIAL_PASSWORD = "harbor_registry_password"
  }

  type = "Opaque"
}

