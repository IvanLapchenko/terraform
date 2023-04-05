resource "kubernetes_config_map" "harbor_core" {
  depends_on = [
    kubernetes_manifest.redis_cluster
  ]
  metadata {
    name      = "harbor-core"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    CHART_CACHE_DRIVER = "redis"

    CHART_REPOSITORY_URL = "http://harbor-chartmuseum"

    CONFIG_PATH = "/etc/core/app.conf"

    CORE_LOCAL_URL = "http://127.0.0.1:8080"

    CORE_URL = "http://harbor-core:80"

    DATABASE_TYPE = "postgresql"

    EXT_ENDPOINT = "http://core.harbor.domain"

    JOBSERVICE_URL = "http://harbor-jobservice"

    LOG_LEVEL = "info"

    NOTARY_URL = "http://harbor-notary-server:4443"

    NO_PROXY = "harbor-core,harbor-jobservice,harbor-database,harbor-chartmuseum,harbor-notary-server,harbor-notary-signer,harbor-registry,harbor-portal,harbor-trivy,harbor-exporter,127.0.0.1,localhost,.local,.internal"

    PERMITTED_REGISTRY_TYPES_FOR_PROXY_CACHE = "docker-hub,harbor,azure-acr,aws-ecr,google-gcr,quay,docker-registry,jfrog-artifactory"

    PORT = "8080"

    PORTAL_URL = "http://harbor-portal"

    POSTGRESQL_DATABASE = "postgres"

    POSTGRESQL_HOST = "bitnami-pg-postgresql.pg-namespace.svc.cluster.local"

    POSTGRESQL_MAX_IDLE_CONNS = "100"

    POSTGRESQL_MAX_OPEN_CONNS = "900"

    POSTGRESQL_PORT = "5432"

    POSTGRESQL_SSLMODE = "disable"

    POSTGRESQL_USERNAME = "postgres"

    REGISTRY_CONTROLLER_URL = "http://harbor-registry:8080"

    REGISTRY_CREDENTIAL_USERNAME = "harbor_registry_user"

    REGISTRY_STORAGE_PROVIDER_NAME = "filesystem"

    REGISTRY_URL = "http://harbor-registry:5000"

    TOKEN_SERVICE_URL = "http://harbor-core:80/service/token"

    TRIVY_ADAPTER_URL = "http://harbor-trivy:8080"

    WITH_CHARTMUSEUM = "true"

    WITH_NOTARY = "false"

    WITH_TRIVY = "false"

    _REDIS_URL_CORE = "redis://user:@rfr-redis-0.rfr-redis.redis-namespace.svc.cluster.local:6379"

    _REDIS_URL_REG = "redis://user:@rfr-redis-0.rfr-redis.redis-namespace.svc.cluster.local:6379"

    "app.conf" = "appname = Harbor\nrunmode = prod\nenablegzip = true\n\n[prod]\nhttpport = 8080\n"
  }
}

