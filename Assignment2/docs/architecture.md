Multi-Tier Web Architecture – Assignment 2
Overview

This project implements a secure multi-tier web application architecture on AWS using Terraform.
The infrastructure is fully modular, reusable, and follows Infrastructure as Code (IaC) best practices.

The design separates networking, security, and web server resources into dedicated Terraform modules.

Architecture Components
1. Networking Layer (VPC Module)

This layer is responsible for network isolation and connectivity.

Resources:

Custom VPC

Public Subnet

Internet Gateway

Route Table & Associations

Purpose:

Provides isolated cloud network

Enables public internet access to web servers

2. Security Layer (Security Module)

Controls traffic and access rules.

Resources:

Security Groups

Inbound rules:

Port 22 (SSH)

Port 80 (HTTP)

Port 443 (HTTPS)

Purpose:

Protects EC2 instances from unauthorized access

Only required ports are exposed

3. Web Server Layer (Webserver Module)

Hosts the application layer.

Resources:

EC2 Instances

User-data startup scripts

Key pair for SSH

Two server types:

Nginx Server

Apache Server

Purpose:

Serves web content

Automatically installs web server software at launch

Automation Flow:

Terraform provisions networking infrastructure

Security rules are applied

EC2 instances are launched

Startup scripts configure Nginx and Apache automatically

Public IPs are output for browser access

┌─────────────────────────────────────────────────┐
│                  Internet                       │
└─────────────────┬───────────────────────────────┘
                  │
                  │ HTTPS (443)
                  │ HTTP (80)
                  ▼
         ┌────────────────────┐
         │   Nginx Server     │
         │  (Load Balancer)   │
         │   - SSL/TLS        │
         │   - Caching        │
         │   - Reverse Proxy  │
         └────────┬───────────┘
                  │
      ┌───────────┼───────────┐
      │           │           │
      ▼           ▼           ▼
   ┌─────┐     ┌─────┐     ┌─────┐
   │Web-1│     │Web-2│     │Web-3│
   │     │     │     │     │(BKP)│
   └─────┘     └─────┘     └─────┘
   Primary     Primary     Backup