variable "region" {
  description = "AWS region"
  type        = string
  default     = "me-central-1"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "me-central-1a"
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
}

variable "public_key" {
  description = "SSH public key"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "env_prefix" {
  description = "Prefix for naming instances"
  type        = string
  default     = "labproj"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}
