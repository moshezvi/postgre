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

module bastion {
  source = "./modules/bastion"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id
  ami_id = "ami-04f167a56786e4b09" 
  instance_type = "t3.micro"
  key_name = "mozvi_key"
  my_ip = "216.71.192.93/32" # Replace with your public IP address in CIDR notation
}
