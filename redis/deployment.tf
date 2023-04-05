resource "kubernetes_deployment" "redis-operator" {
  depends_on = [
    kubernetes_namespace.redis
  ]
  metadata {
    name      = "redis-operator"
    namespace = var.namespace
    labels = {
      "app"     = "redis-operator"
      "release" = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app"     = "redis-operator"
        "release" = "redis"
      }
    }

    template {
      metadata {
        labels = {
          "app"     = "redis-operator"
          "release" = "redis"
        }
      }

      spec {

        # service_account_name = redis-operator
        container {
          name  = "redis-operator"
          image = "quay.io/spotahome/redis-operator:v1.2.4"

          port {
            name           = "metrics"
            container_port = 9710
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu = "100m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "128Mi"
            }
          }

          liveness_probe {
            tcp_socket {
              port = "9710"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 5
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            tcp_socket {
              port = "9710"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user               = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        service_account_name = "redis-operator-service-account"
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }
}

