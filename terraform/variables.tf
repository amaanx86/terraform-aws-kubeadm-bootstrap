variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "kubeadm-bootstrap"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.22.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.22.1.0/24", "10.22.2.0/24"]
}

variable "manage_default_route_table" {
  description = "Manage the default route table"
  type        = bool
  default     = true
}

variable "manage_default_network_acl" {
  description = "Adopt and manage the default network ACL"
  type        = bool
  default     = true
}

variable "public_dedicated_network_acl" {
  description = "Use a dedicated NACL for public subnets"
  type        = bool
  default     = true
}

variable "ubuntu_version" {
  description = "Ubuntu LTS version for EC2 instances (e.g. 24.04, 26.04)"
  type        = string
  default     = "24.04"

  validation {
    condition     = can(regex("^[0-9]{2}\\.[0-9]{2}$", var.ubuntu_version))
    error_message = "ubuntu_version must be in YY.MM format, e.g. 24.04 or 26.04."
  }
}

variable "control_plane_instance_type" {
  description = "EC2 instance type for the kubeadm control plane"
  type        = string
  default     = "t3.medium"
}

variable "worker_instance_type" {
  description = "EC2 instance type for the kubeadm worker node"
  type        = string
  default     = "t3.medium"
}
