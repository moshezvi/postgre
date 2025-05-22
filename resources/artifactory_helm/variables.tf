variable "postgresql_host" {
  description = "The hostname of the PostgreSQL database"
  type        = string
  default     = ""    
}

variable "postgresql_port" {
  description = "The port of the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "postgresql_sslmode" {
  description = "The SSL mode for the PostgreSQL database"
  type        = string
  default     = "require"

  validation {
    condition     = contains(["disable", "allow", "prefer", "require", "verify-ca", "verify-full"], var.postgresql_sslmode)
    error_message = "Invalid sslmode. Allowed values: disable, allow, prefer, require, verify-ca, verify-full."
  }
}

variable "postgresql_db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "postgres"  
}

variable "postgresql_admin_user" {
  description = "The password for the PostgreSQL database"
  type        = string
  default     = ""  
}

variable "postgresql_admin_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  default     = ""  
  sensitive = true
}

variable "artifactory_db_user" {
  description = "The username for the Artifactory database"
  type        = string
  default     = "artifactory"  
}

variable "artifactory_db_password" {
  description = "The password for the Artifactory database"
  type        = string
  default     = ""  
  sensitive = true
}

variable "artifactory_db_name" {
  description = "The name of the Artifactory database"
  type        = string
  default     = "artifactory"  
}
