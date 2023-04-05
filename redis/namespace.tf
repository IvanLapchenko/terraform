resource "kubernetes_namespace" "redis" {
  metadata {
    name = var.namespace
  }
}