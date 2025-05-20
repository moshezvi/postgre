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

# EKS Cluster Variables
# variable "cluster_name" {
#   description = "The name of the EKS cluster"
#   type        = string  
# }

variable "region" {
  description = "The AWS region to deploy the EKS cluster"
  type        = string
  default     = "us-east-2"
}

variable "my_ip" {
  description = "My IP for remote access"
  type = string
}


# variable "node_group_name" {
#   description = "The name of the EKS node group"
#   type        = string
#   default     = "ng-artifactory-2"
# }


