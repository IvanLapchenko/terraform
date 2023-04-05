resource "kubernetes_secret" "bitnami_pg_postgresql" {
  depends_on = [
    kubernetes_namespace.pg
  ]
  
  metadata {
    name      = "bitnami-pg-postgresql"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/instance" = "bitnami-pg"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name" = "postgresql"
      "helm.sh/chart" = "postgresql-12.2.6"
    }
  }

  data = {
    postgres-password = "r8R63g6qNJ"
  }

  type = "Opaque"
}

