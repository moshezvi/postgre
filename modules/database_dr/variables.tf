variable "db_arn" {
  type        = string
  description = "ARN of the database"
}

variable "target_region" {
  type        = string
  description = "Target region for the DR database" 
}
