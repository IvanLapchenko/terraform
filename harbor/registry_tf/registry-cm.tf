resource "kubernetes_config_map" "harbor_registry" {
  metadata {
    name      = "harbor-registry"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    "config.yml" = local.registry_config

    "ctl-config.yml" = "---\nprotocol: \"http\"\nport: 8080\nlog_level: info\nregistry_config: \"/etc/registry/config.yml\"\n"
  }
}

