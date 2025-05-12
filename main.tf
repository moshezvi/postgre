module database {
  source = "./modules/database"
  db_identifier = "artifactory-pg-12"
  db_engine_version = "12"
  db_password = var.db_password
  db_username = var.db_username
  db_allocated_storage = 20
  db_instance_class = "db.t3.micro"
}
