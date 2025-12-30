variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
}

variable "subnet_cidr_block" {
  type        = string
  description = "CIDR block for subnet"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone"
}

variable "env_prefix" {
  type        = string
  description = "Environment prefix"
}
