locals {
  registry_config = <<EOT
version: 0.1
log:
  level: info
  fields:
    service: registry
storage:
  filesystem:
    rootdirectory: /storage
  cache:
    layerinfo: redis
  maintenance:
    uploadpurging:
      enabled: true
      age: 168h
      interval: 24h
      dryrun: false
  delete:
    enabled: true
  redirect:
    disable: false
redis:
  addr: redis://user:@rfr-redis-0.rfr-redis.redis-namespace.svc.cluster.local:6379
  db: 2
  password: admin
  readtimeout: 10s
  writetimeout: 10s
  dialtimeout: 10s
  pool:
    maxidle: 100
    maxactive: 500
    idletimeout: 60s
http:
  addr: :5000
  relativeurls: false
  # set via environment variable
  # secret: placeholder
  debug:
    addr: localhost:5001
auth:
  htpasswd:
    realm: harbor-registry-basic-realm
    path: /etc/registry/passwd
validation:
  disabled: true
compatibility:
  schema1:
    enabled: true


  EOT
}

