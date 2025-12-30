variable "env_prefix" {
  type        = string
  description = "Environment prefix"
}

variable "instance_name" {
  type        = string
  description = "Instance name"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone to deploy instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where instance will be launched"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where instance will be launched"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to attach"
}

variable "public_key" {
  type        = string
  description = "Path to public SSH key"
}

variable "script_path" {
  type        = string
  description = "Path to user data script"
}

variable "instance_suffix" {
  type        = string
  description = "Suffix for unique instance naming"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources"
}
