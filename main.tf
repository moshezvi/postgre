provider "aws" {
  region = "us-east-2"
}

module vpc {
  source = "./modules/vpc"
}

module database {
  source = "./modules/database"
  db_identifier = "artifactory-pg-12"
  db_engine_version = "12"
  db_password = var.db_password
  db_username = var.db_username
  db_allocated_storage = 20
  db_instance_class = "db.t3.micro"
  db_subnet_ids = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
} 
