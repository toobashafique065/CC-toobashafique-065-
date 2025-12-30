#!/bin/bash 
exec > /home/ec2-user/user-data.log 2>&1 
set -xe

########################################
# Install Nginx + OpenSSL
########################################
dnf update -y 
dnf install -y nginx openssl 
systemctl start nginx 
systemctl enable nginx

########################################
# SSL Setup
########################################
mkdir -p /etc/ssl/private /etc/ssl/certs

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/selfsigned.key \
  -out /etc/ssl/certs/selfsigned.crt \
  -subj "/CN=$PUBLIC_IP" \
  -addext "subjectAltName=IP:$PUBLIC_IP"

########################################
# Backup default config
########################################
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

########################################
# Write NGINX CONFIG
########################################
cat > /etc/nginx/nginx.conf <<'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events { worker_connections 1024; }

http {
    log_format main '$remote_addr - $time_local "$request" '
                    '$status Cache:$upstream_cache_status';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    keepalive_timeout 65;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    gzip on;

    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m;

    upstream backend_servers {
        server BACKEND_IP_1:80;
        server BACKEND_IP_2:80;
        server BACKEND_IP_3:80 backup;
    }

    server {
        listen 443 ssl;
        server_name _;

        ssl_certificate /etc/ssl/certs/selfsigned.crt;
        ssl_certificate_key /etc/ssl/private/selfsigned.key;

        add_header X-Frame-Options SAMEORIGIN always;
        add_header X-Content-Type-Options nosniff always;
        add_header X-XSS-Protection "1; mode=block" always;

        location / {
            proxy_pass http://backend_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            proxy_cache my_cache;
            proxy_cache_valid 200 60m;
            add_header X-Cache $upstream_cache_status;
        }

        location /health {
            return 200 "NGINX OK\n";
        }
    }

    server {
        listen 80;
        return 301 https://$host$request_uri;
    }
}
EOF

########################################
mkdir -p /var/cache/nginx
chown -R nginx:nginx /var/cache/nginx

nginx -t && systemctl restart nginx

echo "NGINX READY"
