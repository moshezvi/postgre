# Network Variables
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "The availability zones for the EKS cluster"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "enable_remote_access" {
  description = "Enable SSH access to the EKS cluster"
  type        = bool
  default     = false
}

variable "my_ip" {
  description = "My IP for remote access"
  type = string
  default = ""
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default = ""
}

# EKS Cluster Variables
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string  
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "region" {
  description = "The AWS region to deploy the EKS cluster"
  type        = string
  default     = "us-east-2"
}

variable "node_group_instance_type" {
  description = "The instance type for the EKS node group"
  type        = string
  default     = "t3.medium"
}

variable "node_group_min_size" {
  description = "The minimum size of the EKS node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "The maximum size of the EKS node group"
  type        = number
  default     = 3
}

variable "node_group_desired_size" {
  description = "The desired size of the EKS node group"
  type        = number
  default     = 2
}
