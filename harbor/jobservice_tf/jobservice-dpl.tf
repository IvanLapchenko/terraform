resource "kubernetes_deployment" "harbor_jobservice" {
  depends_on = [
    kubernetes_persistent_volume_claim.harbor_jobservice,
    kubernetes_config_map.harbor_jobservice,
    kubernetes_config_map.harbor_jobservice_env
  ]
  metadata {
    name      = "harbor-jobservice"
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
          "checksum/configmap" = "7bd48041ff043dbe397e5cb5935952a20cf0ecaa9aafb687d35df36e0fc865bf"

          "checksum/configmap-env" = "fc5293d38623667582757ec2c9a2d17302e1e29e21719423151e921bb7094792"

          "checksum/secret" = "89b3c2a437a3fada4c7c88ab6166dc6e4f4d0f55fa43936a22898ffe591108b9"

          "checksum/secret-core" = "6b44e00eb6f8775d4984aad1dc08467a0a83f76ef2cd6eb30bc5d5adf42ed8f0"
        }
      }

      spec {
        volume {
          name = "jobservice-config"

          config_map {
            name = "harbor-jobservice"
          }
        }

        volume {
          name = "job-logs"

          persistent_volume_claim {
            claim_name = "harbor-jobservice"
          }
        }

        container {
          name  = "jobservice"
          image = "goharbor/harbor-jobservice:v2.7.1"

          port {
            container_port = 8080
          }

          env_from {
            config_map_ref {
              name = "harbor-jobservice-env"
            }
          }

          env_from {
            secret_ref {
              name = "harbor-jobservice"
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

          volume_mount {
            name       = "jobservice-config"
            mount_path = "/etc/jobservice/config.yml"
            sub_path   = "config.yml"
          }

          volume_mount {
            name       = "job-logs"
            mount_path = "/var/log/jobs"
          }

          liveness_probe {
            http_get {
              path   = "/api/v1/stats"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 300
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path   = "/api/v1/stats"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 20
            period_seconds        = 10
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

    strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

