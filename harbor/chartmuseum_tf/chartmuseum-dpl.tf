resource "kubernetes_deployment" "harbor_chartmuseum" {
  depends_on = [
    kubernetes_config_map.harbor_chartmuseum
  ]
  metadata {
    name      = "harbor-chartmuseum"
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
          "checksum/configmap" = "6fe7c90509163a9d7fee36b9862a7b850e341a932f6e1a5540e4ef9ee2cd10b5"

          "checksum/secret" = "af2d2d7c779ee2552af10cb92ccf2d2014e0ad2e7697d27c204c8dc0d7d69680"

          "checksum/secret-core" = "f575a22eb2492a550e6531af8eb99ecab45caf9a936b0d27922e8b78c03cd915"
        }
      }

      spec {
        volume {
          name = "chartmuseum-data"

          persistent_volume_claim {
            claim_name = "harbor-chartmuseum"
          }
        }

        container {
          name  = "chartmuseum"
          image = "goharbor/chartmuseum-photon:v2.7.1"

          port {
            container_port = 9999
          }

          env_from {
            config_map_ref {
              name = "harbor-chartmuseum"
            }
          }

          env_from {
            secret_ref {
              name = "harbor-chartmuseum"
            }
          }

          env {
            name = "BASIC_AUTH_PASS"

            value_from {
              secret_key_ref {
                name = "harbor-core"
                key  = "secret"
              }
            }
          }

          env {
            name  = "AWS_SDK_LOAD_CONFIG"
            value = "1"
          }

          volume_mount {
            name       = "chartmuseum-data"
            mount_path = "/chart_storage"
          }

          liveness_probe {
            http_get {
              path   = "/health"
              port   = "9999"
              scheme = "HTTP"
            }

            initial_delay_seconds = 300
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path   = "/health"
              port   = "9999"
              scheme = "HTTP"
            }

            initial_delay_seconds = 1
            period_seconds        = 10
          }

          image_pull_policy = "IfNotPresent"
        }

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

