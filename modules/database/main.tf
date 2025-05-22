resource "aws_db_subnet_group" "pg_subnet_group" {
  name       = "pg-subnet-group"
  subnet_ids = var.db_subnet_ids  

  description = "Subnet group for Postgres DB"
  tags = {
    Name = "pg-subnet-group"
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "postgres-sg"
  description = "Allow Postgres traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs # Update later with EKS node CIDRs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgres-sg"
  }
}

#### TODO - Check this
resource "aws_db_parameter_group" "pg_12_custom" {
  name        = "pg-12-custom"
  family      = "postgres12"  # Must match the correct version family
  description = "Custom parameter group for PostgreSQL 12"
  

  parameter {
    name  = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "rds.force_ssl"
    value = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_kms_key" "db_kms_key" {
  description = "Encryption key for DB ${var.db_identifier}"
}

resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  storage_type            = "gp3"
  multi_az                = var.multi_az  # Enables standby instance
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.pg_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.postgres_sg.id]
  publicly_accessible     = var.publicly_accessible
  
  # configurations
  parameter_group_name    = aws_db_parameter_group.pg_12_custom.name
  deletion_protection     = var.deletion_protection
  apply_immediately       = var.apply_immediately
  blue_green_update {
    enabled = true
  }

  # encryption
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.db_kms_key.id

  # backup and retention
  backup_retention_period = var.backup_retention_period
  backup_window = var.backup_window
  maintenance_window = var.maintenance_window
  final_snapshot_identifier = "${var.db_identifier}-final-snapshot"
  skip_final_snapshot     = var.skip_final_snapshot

  tags = {
    Name = var.db_identifier
  }
}
