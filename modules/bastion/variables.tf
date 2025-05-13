# VPC variables
# These variables are used to create the VPC and subnets for the database
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

# Bastion host variables

variable "ami_id" {
  type        = string
  description = "AMI ID for the bastion host"
  default     = "ami-04f167a56786e4b09" # Example AMI ID for Amazon Linux 2 in us-east-2
}

variable "instance_type" { 
  type    = string
  description = "Instance type for the bastion host"
  default = "t3.micro" 
}

variable "key_name" {
  type        = string
  description = "Key pair name for SSH access"
}

variable "my_ip" {
  type        = string
  description = "Your public IP address in CIDR notation (e.g., 13.0.112.3/32)"
}
