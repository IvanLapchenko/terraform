resource "kubernetes_stateful_set" "bitnami_pg_postgresql" {
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
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "primary"

        "app.kubernetes.io/instance" = "bitnami-pg"

        "app.kubernetes.io/name" = "postgresql"
      }
    }

    template {
      metadata {
        name = "bitnami-pg-postgresql"

        labels = {
          "app.kubernetes.io/component" = "primary"

          "app.kubernetes.io/instance" = "bitnami-pg"

          "app.kubernetes.io/managed-by" = "Helm"

          "app.kubernetes.io/name" = "postgresql"

          "helm.sh/chart" = "postgresql-12.2.6"
        }
      }

      spec {
        volume {
          name = "dshm"

          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name    = "init-chmod-data"
          image   = "docker.io/bitnami/bitnami-shell:11-debian-11-r99"
          command = ["/bin/sh", "-ec", "chown 1001:1001 /bitnami/postgresql\nmkdir -p /bitnami/postgresql/data\nchmod 700 /bitnami/postgresql/data\nfind /bitnami/postgresql -mindepth 1 -maxdepth 1 -not -name \"conf\" -not -name \".snapshot\" -not -name \"lost+found\" | \\\n  xargs -r chown -R 1001:1001\nchmod -R 777 /dev/shm\n"]

          volume_mount {
            name       = "data"
            mount_path = "/bitnami/postgresql"
          }

          volume_mount {
            name       = "dshm"
            mount_path = "/dev/shm"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user = 0
          }
        }

        container {
          name  = "postgresql"
          image = "docker.io/bitnami/postgresql:15.2.0-debian-11-r14"

          port {
            name           = "tcp-postgresql"
            container_port = 5432
          }

          env {
            name  = "BITNAMI_DEBUG"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_PORT_NUMBER"
            value = "5432"
          }

          env {
            name  = "POSTGRESQL_VOLUME_DIR"
            value = "/bitnami/postgresql"
          }

          env {
            name  = "PGDATA"
            value = "/bitnami/postgresql/data"
          }

          env {
            name = "POSTGRES_PASSWORD"

            value_from {
              secret_key_ref {
                name = "bitnami-pg-postgresql"
                key  = "postgres-password"
              }
            }
          }

          env {
            name  = "POSTGRESQL_ENABLE_LDAP"
            value = "no"
          }

          env {
            name  = "POSTGRESQL_ENABLE_TLS"
            value = "no"
          }

          env {
            name  = "POSTGRESQL_LOG_HOSTNAME"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_LOG_CONNECTIONS"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_LOG_DISCONNECTIONS"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_PGAUDIT_LOG_CATALOG"
            value = "off"
          }

          env {
            name  = "POSTGRESQL_CLIENT_MIN_MESSAGES"
            value = "error"
          }

          env {
            name  = "POSTGRESQL_SHARED_PRELOAD_LIBRARIES"
            value = "pgaudit"
          }

          resources {
            requests = {
              cpu = "250m"

              memory = "256Mi"
            }
          }

          volume_mount {
            name       = "dshm"
            mount_path = "/dev/shm"
          }

          volume_mount {
            name       = "data"
            mount_path = "/bitnami/postgresql"
          }

          liveness_probe {
            exec {
              command = ["/bin/sh", "-c", "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432"]
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            exec {
              command = ["/bin/sh", "-c", "-e", "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432\n[ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]\n"]
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user = 1001
          }
        }

        service_account_name = "default"

        security_context {
          fs_group = 1001
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "primary"

                    "app.kubernetes.io/instance" = "bitnami-pg"

                    "app.kubernetes.io/name" = "postgresql"
                  }
                }

                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "8Gi"
          }
        }
      }
    }

    service_name = "bitnami-pg-postgresql-hl"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

