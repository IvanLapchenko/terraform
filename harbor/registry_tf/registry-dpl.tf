resource "kubernetes_deployment" "harbor_registry" {
  depends_on = [
    kubernetes_secret.harbor_registry_htpasswd,
    kubernetes_config_map.harbor_registry,
    kubernetes_persistent_volume_claim.harbor_registry
  ]
  metadata {
    name      = "harbor-registry"
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
          "checksum/configmap" = "1233988a6ec26ead3b22a8344c887af99626424b651ddd58cb67c31f5992219c"

          "checksum/secret" = "a0060f87ad8a449b2ba16353f6b5b19b566d3e680ce977cb207849135c0bad87"

          "checksum/secret-core" = "51ebfa8d56ca4dc2221a706148f5f429e98a974d7a925cc0794ee9e66b5e1551"

          "checksum/secret-jobservice" = "1f7011eab129577b5f13634d49e8a5bb2837db663b15a0881e282136298c181a"
        }
      }

      spec {
        volume {
          name = "registry-htpasswd"

          secret {
            secret_name = "harbor-registry-htpasswd"

            items {
              key  = "REGISTRY_HTPASSWD"
              path = "passwd"
            }
          }
        }

        volume {
          name = "registry-config"

          config_map {
            name = "harbor-registry"
          }
        }

        volume {
          name = "registry-data"

          persistent_volume_claim {
            claim_name = "harbor-registry"
          }
        }

        container {
          name  = "registry"
          image = "goharbor/registry-photon:v2.7.1"
          args  = ["serve", "/etc/registry/config.yml"]

          port {
            container_port = 5000
          }

          port {
            container_port = 5001
          }

          env_from {
            secret_ref {
              name = "harbor-registry"
            }
          }

          volume_mount {
            name       = "registry-data"
            mount_path = "/storage"
          }

          volume_mount {
            name       = "registry-htpasswd"
            mount_path = "/etc/registry/passwd"
            sub_path   = "passwd"
          }

          volume_mount {
            name       = "registry-config"
            mount_path = "/etc/registry/config.yml"
            sub_path   = "config.yml"
          }

          liveness_probe {
            http_get {
              path   = "/"
              port   = "5000"
              scheme = "HTTP"
            }

            initial_delay_seconds = 300
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = "5000"
              scheme = "HTTP"
            }

            initial_delay_seconds = 1
            period_seconds        = 10
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "registryctl"
          image = "goharbor/harbor-registryctl:v2.7.1"

          port {
            container_port = 8080
          }

          env_from {
            config_map_ref {
              name = "harbor-registryctl"
            }
          }

          env_from {
            secret_ref {
              name = "harbor-registry"
            }
          }

          env_from {
            secret_ref {
              name = "harbor-registryctl"
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
            name       = "registry-data"
            mount_path = "/storage"
          }

          volume_mount {
            name       = "registry-config"
            mount_path = "/etc/registry/config.yml"
            sub_path   = "config.yml"
          }

          volume_mount {
            name       = "registry-config"
            mount_path = "/etc/registryctl/config.yml"
            sub_path   = "ctl-config.yml"
          }

          liveness_probe {
            http_get {
              path   = "/api/health"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 300
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path   = "/api/health"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 1
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

