resource "kubernetes_namespace" "harbor_namespace" {
  metadata {
    name = var.namespace
  }
}