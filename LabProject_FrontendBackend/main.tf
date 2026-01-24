provider "aws" {
  region = var.region
}

# ------------------------
# VPC & Networking
# ------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ------------------------
# Security Group
# ------------------------
resource "aws_security_group" "web_sg" {
  name   = "${var.env_prefix}-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------------------
# Frontend EC2
# ------------------------
resource "aws_instance" "frontend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]  # <--- CHANGE HERE
  tags = {
    Name = "${var.env_prefix}-frontend"
    Role = "frontend"
  }
}
# ------------------------
# Backend EC2s
# ------------------------
resource "aws_instance" "backend" {
  count                       = 3
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]  # <--- CHANGE HERE
  tags = {
    Name = "${var.env_prefix}-backend-${count.index + 1}"
    Role = "backends"
  }
}
# ------------------------
# Trigger Ansible
# ------------------------
resource "null_resource" "ansible_config" {
  depends_on = [
    aws_instance.frontend,
    aws_instance.backend
  ]

  provisioner "local-exec" {
    command = <<EOT
      cd ansible
      ansible-playbook -i inventory/aws_ec2.yaml playbooks/site.yaml
    EOT
  }
}
