provider "postgresql" {
  scheme   = "awspostgres"
  host     = var.postgresql_host
  port     = var.postgresql_port
  database = var.postgresql_db_name
  username = var.postgresql_admin_user
  password = var.postgresql_admin_password
  sslmode  = var.postgresql_sslmode
  expected_version = "12.22"
  superuser = false
}

# PostgreSQL elements
# -------------------

resource "postgresql_role" "artifactory_db_user" {
  name     = var.artifactory_db_user
  login    = true
  password = var.artifactory_db_password
}

resource "postgresql_database" "artifactory_db" {
  name  = var.artifactory_db_name
  owner = postgresql_role.artifactory_db_user.name
}
