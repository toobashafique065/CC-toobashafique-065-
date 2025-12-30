variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr_block))
    error_message = "Invalid VPC CIDR block."
  }
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr_block))
    error_message = "Invalid subnet CIDR block."
  }
}

variable "availability_zone" {
  description = "Availability zone to deploy resources"
  type        = string
  default     = "me-central-1a"
}

variable "env_prefix" {
  description = "Environment name prefix"
  type        = string
  default     = "prod"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_key" {
  description = "Path to public SSH key"
  type        = string
}

variable "private_key" {
  description = "Path to private SSH key"
  type        = string
}

variable "backend_servers" {
  description = "Backend web servers configuration"
  type = list(object({
    name        = string
    suffix      = string
    script_path = string
  }))
}
