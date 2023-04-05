resource "kubernetes_config_map" "harbor_chartmuseum" {
  metadata {
    name      = "harbor-chartmuseum"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  data = {
    ALLOW_OVERWRITE = "true"

    AUTH_ANONYMOUS_GET = "false"

    BASIC_AUTH_USER = "chart_controller"

    CACHE = "redis"

    CACHE_REDIS_ADDR = "redis://user:@rfr-redis-0.rfr-redis.redis-namespace.svc.cluster.local:6379"

    CACHE_REDIS_DB = "3"

    CHART_POST_FORM_FIELD_NAME = "chart"

    DEBUG = "false"

    DEPTH = "1"

    DISABLE_API = "false"

    DISABLE_METRICS = "false"

    DISABLE_STATEFILES = "false"

    INDEX_LIMIT = "0"

    LOG_JSON = "true"

    MAX_STORAGE_OBJECTS = "0"

    MAX_UPLOAD_SIZE = "20971520"

    PORT = "9999"

    PROV_POST_FORM_FIELD_NAME = "prov"

    STORAGE = "local"

    STORAGE_LOCAL_ROOTDIR = "/chart_storage"

    STORAGE_TIMESTAMP_TOLERANCE = "1s"
  }
}

