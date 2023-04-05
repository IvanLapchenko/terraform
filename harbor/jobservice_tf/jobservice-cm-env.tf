resource "kubernetes_config_map" "harbor_jobservice_env" {
  metadata {
    name      = "harbor-jobservice-env"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    CORE_URL = "http://harbor-core:80"

    NO_PROXY = "harbor-core,harbor-jobservice,harbor-database,harbor-chartmuseum,harbor-notary-server,harbor-notary-signer,harbor-registry,harbor-portal,harbor-trivy,harbor-exporter,127.0.0.1,localhost,.local,.internal"

    REGISTRY_CONTROLLER_URL = "http://harbor-registry:8080"

    REGISTRY_CREDENTIAL_USERNAME = "harbor_registry_user"

    REGISTRY_URL = "http://harbor-registry:5000"

    TOKEN_SERVICE_URL = "http://harbor-core:80/service/token"
  }
}

