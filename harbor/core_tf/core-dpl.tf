resource "kubernetes_deployment" "harbor_core" {
  depends_on = [
    kubernetes_config_map.harbor_core,
    kubernetes_manifest.redis_cluster,
    time_sleep.wait_couple_seconds
  ]
  metadata {
    name      = "harbor-core"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "harbor"
      }
    }

    template {
      metadata {
        labels = {
          app = "harbor"
        }

        annotations = {
          "checksum/configmap" = "2af662d72f15ce08f667474c33a662bc521adc5469733d95a362b174fc97b560"

          "checksum/secret" = "93aa93d4115a00a5e9f686683c87947e369544e31f14e2f8da92e762d22cd78f"

          "checksum/secret-jobservice" = "b8dee830fea5528db070cbe1788b13b4399b4f963d6838a6bc8a8d1bae31ef7a"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "harbor-core"

            items {
              key  = "app.conf"
              path = "app.conf"
            }
          }
        }

        volume {
          name = "secret-key"

          secret {
            secret_name = "harbor-core"

            items {
              key  = "secretKey"
              path = "key"
            }
          }
        }

        volume {
          name = "token-service-private-key"

          secret {
            secret_name = "harbor-core"
          }
        }

        volume {
          name = "psc"
          empty_dir {}
        }

        container {
          name  = "core"
          image = "goharbor/harbor-core:v2.7.1"

          port {
            container_port = 8080
          }

          env_from {
            config_map_ref {
              name = "harbor-core"
            }
          }

          env_from {
            secret_ref {
              name = "harbor-core"
            }
          }

          env {
            name = "CORE_SECRET"

            value_from {
              secret_key_ref {
                name = "harbor-core"
                key  = "secret"
              }
            }
          }

          env {
            name = "JOBSERVICE_SECRET"

            value_from {
              secret_key_ref {
                name = "harbor-jobservice"
                key  = "JOBSERVICE_SECRET"
              }
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/core/app.conf"
            sub_path   = "app.conf"
          }

          volume_mount {
            name       = "secret-key"
            mount_path = "/etc/core/key"
            sub_path   = "key"
          }

          volume_mount {
            name       = "token-service-private-key"
            mount_path = "/etc/core/private_key.pem"
            sub_path   = "tls.key"
          }

          volume_mount {
            name       = "psc"
            mount_path = "/etc/core/token"
          }

          liveness_probe {
            http_get {
              path   = "/api/v2.0/ping"
              port   = "8080"
              scheme = "HTTP"
            }

            period_seconds    = 10
            failure_threshold = 2
          }

          readiness_probe {
            http_get {
              path   = "/api/v2.0/ping"
              port   = "8080"
              scheme = "HTTP"
            }

            period_seconds    = 10
            failure_threshold = 2
          }

          startup_probe {
            http_get {
              path   = "/api/v2.0/ping"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            period_seconds        = 10
            failure_threshold     = 360
          }

          image_pull_policy = "IfNotPresent"
        }

        termination_grace_period_seconds = 120

        security_context {
          run_as_user = 10000
          fs_group    = 10000
        }
      }
    }

    revision_history_limit = 10
  }
}

