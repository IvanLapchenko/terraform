resource "kubernetes_config_map" "harbor_portal" {
  metadata {
    name      = "harbor-portal"
    namespace = var.namespace
    labels = {
      app = "harbor"
    }
  }

  # data = {
  #   "nginx.conf" = "worker_processes auto;\npid /tmp/nginx.pid;\nevents {\n    worker_connections  1024;\n}\nhttp {\n    client_body_temp_path /tmp/client_body_temp;\n    proxy_temp_path /tmp/proxy_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n    server {\n        listen 8080;\n        listen [::]:8080;\n        server_name  localhost;\n        root   /usr/share/nginx/html;\n        index  index.html index.htm;\n        include /etc/nginx/mime.types;\n        gzip on;\n        gzip_min_length 1000;\n        gzip_proxied expired no-cache no-store private auth;\n        gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;\n        location /devcenter-api-2.0 {\n            try_files $uri $uri/ /swagger-ui-index.html;\n        }\n        location / {\n            try_files $uri $uri/ /index.html;\n        }\n        location = /index.html {\n            add_header Cache-Control \"no-store, no-cache, must-revalidate\";\n        }\n    }\n}\n"
  # }
}

