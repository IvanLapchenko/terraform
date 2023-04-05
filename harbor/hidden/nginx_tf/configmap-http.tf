resource "kubernetes_config_map" "harbor_nginx" {
  metadata {
    name = "harbor-nginx"

    labels = {
      app = "harbor"
    }
  }

  data = {
    "nginx.conf" = "worker_processes auto;\npid /tmp/nginx.pid;\n\nevents {\n  worker_connections 3096;\n  use epoll;\n  multi_accept on;\n}\n\nhttp {\n  client_body_temp_path /tmp/client_body_temp;\n  proxy_temp_path /tmp/proxy_temp;\n  fastcgi_temp_path /tmp/fastcgi_temp;\n  uwsgi_temp_path /tmp/uwsgi_temp;\n  scgi_temp_path /tmp/scgi_temp;\n  tcp_nodelay on;\n\n  # this is necessary for us to be able to disable request buffering in all cases\n  proxy_http_version 1.1;\n\n  upstream core {\n    server \"harbor-core:80\";\n  }\n\n  upstream portal {\n    server harbor-portal:80;\n  }\n\n  log_format timed_combined '[$time_local]:$remote_addr - '\n    '\"$request\" $status $body_bytes_sent '\n    '\"$http_referer\" \"$http_user_agent\" '\n    '$request_time $upstream_response_time $pipe';\n\n  access_log /dev/stdout timed_combined;\n\n  map $http_x_forwarded_proto $x_forwarded_proto {\n    default $http_x_forwarded_proto;\n    \"\"      $scheme;\n  }\n\n  server {\n    listen 8080;\n    listen [::]:8080;\n    server_tokens off;\n    # disable any limits to avoid HTTP 413 for large image uploads\n    client_max_body_size 0;\n\n    # Add extra headers\n    add_header X-Frame-Options DENY;\n    add_header Content-Security-Policy \"frame-ancestors 'none'\";\n\n    location / {\n      proxy_pass http://portal/;\n      proxy_set_header Host $host;\n      proxy_set_header X-Real-IP $remote_addr;\n      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n      proxy_set_header X-Forwarded-Proto $x_forwarded_proto;\n\n      proxy_buffering off;\n      proxy_request_buffering off;\n    }\n\n    location /api/ {\n      proxy_pass http://core/api/;\n      proxy_set_header Host $host;\n      proxy_set_header X-Real-IP $remote_addr;\n      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n      proxy_set_header X-Forwarded-Proto $x_forwarded_proto;\n\n      proxy_buffering off;\n      proxy_request_buffering off;\n    }\n\n    location /chartrepo/ {\n      proxy_pass http://core/chartrepo/;\n      proxy_set_header Host $host;\n      proxy_set_header X-Real-IP $remote_addr;\n      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n      proxy_set_header X-Forwarded-Proto $x_forwarded_proto;\n\n      proxy_buffering off;\n      proxy_request_buffering off;\n    }\n\n    location /c/ {\n      proxy_pass http://core/c/;\n      proxy_set_header Host $host;\n      proxy_set_header X-Real-IP $remote_addr;\n      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n      proxy_set_header X-Forwarded-Proto $x_forwarded_proto;\n\n      proxy_buffering off;\n      proxy_request_buffering off;\n    }\n\n    location /v1/ {\n      return 404;\n    }\n\n    location /v2/ {\n      proxy_pass http://core/v2/;\n      proxy_set_header Host $http_host;\n      proxy_set_header X-Real-IP $remote_addr;\n      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n      proxy_set_header X-Forwarded-Proto $x_forwarded_proto;\n      proxy_buffering off;\n      proxy_request_buffering off;\n    }\n\n    location /service/ {\n      proxy_pass http://core/service/;\n      proxy_set_header Host $host;\n      proxy_set_header X-Real-IP $remote_addr;\n      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n      proxy_set_header X-Forwarded-Proto $x_forwarded_proto;\n\n      proxy_buffering off;\n      proxy_request_buffering off;\n    }\n\n  location /service/notifications {\n      return 404;\n    }\n  }\n}\n"
  }
}
