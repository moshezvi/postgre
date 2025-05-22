provider "aws" {
  region = var.target_region
}

resource "aws_db_instance_automated_backups_replication" "cross_region_backup" {
  source_db_instance_arn = var.db_arn
  retention_period       = 14
}

