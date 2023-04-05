resource "kubernetes_service_account" "redis_operator" {
  depends_on = [
    kubernetes_namespace.redis
  ]
  metadata {
    name      = "redis-operator-service-account"
    namespace = var.namespace
    labels = {
      "app"     = "redis-operator"
      "release" = "redis"
    }
  }
}

resource "kubernetes_cluster_role" "redis_operator" {
  metadata {
    name = "redis-operator-cluster-role"

    labels = {
      "app"     = "redis-operator"
      "release" = "redis"
    }
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["databases.spotahome.com"]
    resources  = ["redisfailovers", "redisfailovers/finalizers"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["create", "get", "list", "update"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = [""]
    resources  = ["pods", "services", "endpoints", "events", "configmaps", "persistentvolumeclaims", "persistentvolumeclaims/finalizers"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }
}

resource "kubernetes_cluster_role_binding" "redis_operator" {
  metadata {
    name = "redis-operator-binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "redis-operator-service-account"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "redis-operator-cluster-role"
  }
}

# resource "kubernetes_secret" "sa_token" {
#   type = "kubernetes.io/service-account-token"

#   metadata {
#     name      = "sa-secret"
#     namespace = var.namespace
#     annotations = {
#       "kubernetes.io/service-account.name" = "redis-operator"
#     }
#   }

#   depends_on = [
#     kubernetes_service_account.redis_operator
#   ]
# }