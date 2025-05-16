variable "db_username" {
  type        = string
  description = "Master username for the DB"
}

variable "db_password" {
  type        = string
  description = "Master password for the DB"
  sensitive   = true
}

variable "db_identifier" {
  type        = string
  description = "DB identifier"
}

variable "db_engine_version" {
  type        = string
  description = "DB engine version"
}

variable "db_instance_class" {
  type        = string
  description = "DB instance class"
  default     = "db.m5d.large"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage for the DB"
  default     = 400
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ for the DB"
  default     = false
}


# VPC variables
# These variables are used to create the VPC and subnets for the database
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the DB instance is publicly accessible"
  default     = false
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks to allow access to the DB instance"
}
  