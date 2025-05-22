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

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain backups"
  default     = 7
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot before deletion"
  default     = false
} 

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection for the DB instance"
  default     = false
}

variable "apply_immediately" {  #    = true  # Applies changes without waiting for maintenance window
  type        = bool
  description = "Apply changes immediately"
  default     = false
}

# backup window cannot overlap with the maintenance window
# backup window times are in UTC - adjust accordingly
variable "backup_window" {
  type        = string
  description = "Backup window for the DB instance"
  default     = "01:00-01:30"
}

variable "maintenance_window" {
  type        = string
  description = "Maintenance window for the DB instance"
  default     = "Sun:02:00-Sun:03:00"
}
