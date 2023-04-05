resource "kubernetes_deployment" "harbor_portal" {
  depends_on = [
    kubernetes_config_map.harbor_portal
  ]
  metadata {
    name      = "harbor-portal"
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
      }

      spec {
        volume {
          name = "portal-config"

          config_map {
            name = "harbor-portal"
          }
        }

        container {
          name  = "portal"
          image = "goharbor/harbor-portal:v2.7.1"

          port {
            container_port = 8080
          }

          # volume_mount {
          #   name       = "portal-config"
          #   mount_path = "/etc/nginx/nginx.conf"
          #   sub_path   = "nginx.conf"
          # }

          liveness_probe {
            http_get {
              path   = "/"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 300
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = "8080"
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

    revision_history_limit = 10
  }
}

