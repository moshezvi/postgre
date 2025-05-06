variable "db_username" {
  type        = string
  description = "Master username for the DB"
}

variable "db_password" {
  type        = string
  description = "Master password for the DB"
  sensitive   = true
}
