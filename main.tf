module "redis_operator_crds" {
  source = "./redis/crds"
}

module "redis_operator" {
  source     = "./redis"
  depends_on = [module.redis_operator_crds]
}

module "pg_operator" {
  source     = "./pg"
}

module "harbor_chartmuseum" {
  source     = "./harbor/chartmuseum_tf"
    depends_on = [module.harbor_secrets,
                  module.harbor_core,
                  module.redis_operator,
                  module.redis_operator_crds]
}

module "harbor_core" {
  source = "./harbor/core_tf"
  depends_on = [module.harbor_secrets,
                module.redis_operator,
                module.redis_operator_crds]
}

module "harbor_jobservice" {
  source = "./harbor/jobservice_tf"
  depends_on = [module.harbor_secrets,
                module.harbor_core,
                module.redis_operator,
                module.redis_operator_crds]
}

module "harbor_secrets" {
  source = "./harbor/secrets_tf"
  depends_on = [module.redis_operator,
                module.redis_operator_crds]
}

module "harbor_portal" {
    source = "./harbor/portal_tf"
    depends_on = [module.harbor_secrets,
                  module.harbor_core,
                  module.redis_operator,
                  module.redis_operator_crds]
}

module "harbor_registry" {
    source = "./harbor/registry_tf"
    depends_on = [module.redis_operator]
}


provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "advantiss"
}