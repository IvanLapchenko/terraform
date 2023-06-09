locals {
  jobservice_config = <<EOT
#Server listening port
protocol: "http"
port: 8080
worker_pool:
  workers: 10
  backend: "redis"
  redis_pool:
    redis_url: "redis://user:@rfr-redis-0.rfr-redis.redis-namespace.svc.cluster.local:6379"
    namespace: "${var.namespace}"
    idle_timeout_second: 3600
job_loggers:
  - name: "FILE"
    level: INFO
    settings: # Customized settings of logger
      base_dir: "/var/log/jobs"
    sweeper:
      duration: 14 #days`
      settings: # Customized settings of sweeper
        work_dir: "/var/log/jobs"
metric:
  enabled: false
  path: /metrics
  port: 8001
#Loggers for the job service
loggers:
  - name: "STD_OUTPUT"
    level: INFO

  EOT
}