resource "kubernetes_manifest" "redis_cluster" {

  manifest = {
    "apiVersion" = "databases.spotahome.com/v1"
    "kind"       = "RedisFailover"
    "metadata" = {
      "name"      = "redis"
      "namespace" = var.redis_namespace
    }
    "spec" = {
      "redis" = {
         "exporter" = {
          "enabled" = true
          "image"   = "leominov/redis_sentinel_exporter:1.3.0"
          "args"=[
          "--web.telemetry-path",
           "/metrics"
          ]

      "env"=[{

    "name"= "REDIS_EXPORTER_LOG_FORMAT"
      "value"= "txt"
         }]

        }
        "extraVolumeMounts" = [
          {
            "mountPath" = "/etc/redis"
            "name"      = "redis"
            "readOnly"  = true
          },
        ]
        "extraVolumes" = [
          {
            "name" = "redis"
            "secret" = {
              "optional"   = false
              "secretName" = "redis"
            }
          },
        ]
        "replicas" = 1
      }
      "sentinel" = {
        "exporter" = {
          "enabled" = true
          "image"   = "leominov/redis_sentinel_exporter:1.3.0"
        }
        "extraVolumeMounts" = [
          {
            "mountPath" = "/etc/redis"
            "name"      = "redis"
            "readOnly"  = true
          },
        ]
        "extraVolumes" = [
          {
            "name" = "redis"
            "secret" = {
              "optional"   = false
              "secretName" = "redis"
            }
          },
        ]
        "replicas" = 1
      }
    }
  }
}

resource "time_sleep" "wait_couple_seconds" {
  depends_on = [kubernetes_manifest.redis_cluster]

  create_duration = "30s"
}


# resource "kubectl_manifest" "redis_cluster" {
#     yaml_body = <<YAML
# apiVersion: databases.spotahome.com/v1
# kind: RedisFailover
# metadata:
#   name: redis-harbor
#   namespace: ${var.redis_namespace}
# spec:
#   bootstrapNode:
#     host: "127.0.0.1"
#     port: "6388"
#   sentinel:
#     replicas: 1
#   redis:
#     replicas: 1
# YAML
# }