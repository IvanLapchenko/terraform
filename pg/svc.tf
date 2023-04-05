resource "kubernetes_service" "bitnami_pg_postgresql" {
  depends_on = [
    kubernetes_namespace.pg
  ]
  
  metadata {
    name      = "bitnami-pg-postgresql"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/component" = "primary"
      "app.kubernetes.io/instance" = "bitnami-pg"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name" = "postgresql"
      "helm.sh/chart" = "postgresql-12.2.6"
    }
  }

  spec {
    port {
      name        = "tcp-postgresql"
      port        = 5432
      target_port = "tcp-postgresql"
    }

    selector = {
      "app.kubernetes.io/component" = "primary"
      "app.kubernetes.io/instance" = "bitnami-pg"
      "app.kubernetes.io/name" = "postgresql"
    }

    type             = "ClusterIP"
    session_affinity = "None"
  }
}

