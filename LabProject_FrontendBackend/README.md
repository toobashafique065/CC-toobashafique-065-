# Lab Project – Frontend + Backend Nginx HA with Terraform & Ansible

## 📌 Overview
This project provisions a **highly available frontend–backend architecture** on AWS using **Terraform** for infrastructure and **Ansible** for configuration management.  
- **Frontend:** Nginx load balancer (2 primary backends + 1 backup).  
- **Backends:** Apache HTTPD servers serving distinct content (hostname + private IP).  
- **Automation:** Ansible runs automatically after `terraform apply` (no manual playbook run).

---

## 🚀 How to Run

```bash
terraform init
terraform apply -auto-approve
