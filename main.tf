provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true  # Enable DNS resolution
  enable_dns_hostnames = true  # Enable DNS hostnames
}

# resource "aws_subnet" "private_subnet_1" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-2a"
#   tags = {
#     Name = "private-subnet-1"
#   }
# }

# resource "aws_subnet" "private_subnet_2" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-east-2b"
#   tags = {
#     Name = "private-subnet-2"
#   }
# }

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

# subnet group for the Postgres DB
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  

  description = "Subnet group for Postgres DB - Public"
  tags = {
    Name = "postgres-subnet-group"
  }
}

# internet gateway for external access
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource aws_route_table_association "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource aws_route_table_association "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}



# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   # No route to the IGW; this makes it "private"
  
#   tags = {
#     Name = "private-route-table"
#   }
# }

# resource "aws_route_table_association" "private_subnet_1" {
#   subnet_id      = aws_subnet.private_subnet_1.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_subnet_2" {
#   subnet_id      = aws_subnet.private_subnet_2.id
#   route_table_id = aws_route_table.private.id
# }

resource "aws_security_group" "postgres_sg" {
  name        = "postgres-sg"
  description = "Allow Postgres traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Update later with EKS node CIDRs
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

# Allow access from my IP
resource "aws_security_group_rule" "allow_postgres_from_my_ip" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["216.71.192.93/32"]
  description       = "My IP"
  security_group_id = aws_security_group.postgres_sg.id
}

resource "aws_db_instance" "postgres" {
  identifier              = "artifactory-postgres"
  engine                  = "postgres"
  engine_version          = "12"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  #name                    = "artifactorydb"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.postgres.name
  vpc_security_group_ids  = [aws_security_group.postgres_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = true
}
