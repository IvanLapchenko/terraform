resource "kubernetes_service" "bitnami_pg_postgresql_hl" {
  depends_on = [
    kubernetes_namespace.pg
  ]
  
  metadata {
    name      = "bitnami-pg-postgresql-hl"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/component" = "primary"
      "app.kubernetes.io/instance" = "bitnami-pg"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name" = "postgresql"
      "helm.sh/chart" = "postgresql-12.2.6"
      "service.alpha.kubernetes.io/tolerate-unready-endpoints" = "true"
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

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

