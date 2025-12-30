Project Overview

This project demonstrates a multi-tier web infrastructure on AWS using Terraform and Nginx.

Nginx acts as a reverse proxy/load balancer with caching and HTTPS.

Three backend web servers (web-1, web-2, web-3) handle application traffic with high availability.

Components Description

Nginx Server: Handles HTTPS requests, load balances traffic between web-1 and web-2, serves cached content, and redirects HTTP to HTTPS.

Web Servers: Apache servers (web-1, web-2) serve the application. Web-3 acts as a backup server.

Security Groups: Control inbound/outbound traffic for Nginx and backend servers.

VPC & Subnet: Provides network isolation.

Key Pair: Used for secure SSH access to EC2 instances.

Prerequisites

Required Tools: Terraform, AWS CLI, SSH client (like PuTTY or terminal), Git.

AWS Credentials Setup: Configure aws configure with access key, secret key, region, and output format.

SSH Key Setup: Create key pair and provide .pub and private keys for EC2 access.

Deployment Instructions

Configure variables in terraform.tfvars.

Initialize Terraform: terraform init.

Validate configuration: terraform validate.

Plan deployment: terraform plan.

Apply configuration: terraform apply -auto-approve.

Update Nginx backend IPs in /etc/nginx/nginx.conf using private IPs of web servers.

Reload Nginx: sudo systemctl restart nginx.

Configuration Guide

Backend IPs: Replace placeholders in Nginx upstream block with actual private IPs.

Nginx Config: Handles HTTPS, caching, security headers, and load balancing.

Testing Procedures: Verify load balancing, cache, backup server activation, and HTTPS redirection.

Architecture Details

Network Topology: VPC → Subnet → Nginx → Backend Web Servers.

Security Groups:

Nginx SG: Ports 80/443 open, SSH restricted to your IP.

Backend SG: Only allows traffic from Nginx SG, SSH restricted.

Load Balancing Strategy: Web-1 & Web-2 active, Web-3 backup.

Troubleshooting

Common Issues:

Nginx fails to start → check config sudo nginx -t.

Backend unreachable → verify security group rules.

Log Locations: /var/log/nginx/access.log, /var/log/nginx/error.log, Apache logs /var/log/httpd/.

Debug Commands: systemctl status nginx, tail -f /var/log/nginx/error.log.