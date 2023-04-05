resource "kubernetes_namespace" "pg" {
  metadata {
    name = var.namespace
  }
}