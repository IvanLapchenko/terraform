resource "kubernetes_deployment" "harbor_nginx" {
  metadata {
    name = "harbor-nginx"

    labels = {
      app = "harbor"

      chart = "harbor"

      component = "nginx"

      heritage = "Helm"

      release = "release-name"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "harbor"

        component = "nginx"

        release = "release-name"
      }
    }

    template {
      metadata {
        labels = {
          app = "harbor"

          chart = "harbor"

          component = "nginx"

          heritage = "Helm"

          release = "release-name"
        }

        annotations = {
          "checksum/configmap" = "0141636ffd4fd2208d66c35580de1b031e768831788b84f2870a9b5236528139"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "harbor-nginx"
          }
        }

        container {
          name  = "nginx"
          image = "goharbor/nginx-photon:v2.7.1"

          port {
            container_port = 8080
          }

          port {
            container_port = 8443
          }

          port {
            container_port = 4443
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }

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

