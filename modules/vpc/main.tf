resource "aws_vpc" "pg_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "pg-vpc"
  }
}

locals {
  private_subnets = { for idx, az in var.availability_zones : idx => {
    availability_zone = az
    cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, idx)
  }}

  public_subnets = { for idx, az in var.availability_zones : idx => {
    availability_zone = az
    cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, idx + 100)
  }}
}

# Private Subnets
resource "aws_subnet" "pg_private_subnet" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.pg_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "pg-private-subnet-${each.value.availability_zone}"
  }
}

resource "aws_route_table" "pg_private_rt" {
  vpc_id = aws_vpc.pg_vpc.id

  # No routes for private subnets
  tags = {
    Name = "pg-private-route-table"
  }
}

resource "aws_route_table_association" "private_subnets" {
  for_each = aws_subnet.pg_private_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pg_private_rt.id
}

# Public subnets

resource "aws_subnet" "pg_public_subnet" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.pg_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "pg-public-subnet-${each.value.availability_zone}"
  }
}

resource "aws_internet_gateway" "pg-igw" {
  vpc_id = aws_vpc.pg_vpc.id

  tags = {
    Name = "pg-public-igw"
  }
}

resource "aws_route_table" "pg_public_rt" {
  vpc_id = aws_vpc.pg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pg-igw.id
  }

  tags = {
    Name = "pg-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each = aws_subnet.pg_public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pg_public_rt.id
}




# ### Adding NAT Gateway for outbound internet access
# resource "aws_subnet" "bastion_subnet_1" {
#   vpc_id                  = aws_vpc.postgres_vpc.id
#   cidr_block              = "10.0.10.0/24"
#   availability_zone       = "us-east-2a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "bastion_subnet_1"
#   }
# }

# resource "aws_internet_gateway" "bastion_igw" {
#   vpc_id = aws_vpc.postgres_vpc.id

#   tags = {
#     Name = "bastion-igw"
#   }
# }

# resource "aws_route_table" "bastion_rt" {
#   vpc_id = aws_vpc.postgres_vpc.id
#   # This route table is for the public subnet

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.bastion_igw.id
#   }

#   tags = {
#     Name = "public-route-table"
#   }
# }

# resource "aws_route_table_association" "public_subnet_assoc" {
#   subnet_id      = aws_subnet.bastion_subnet_1.id
#   route_table_id = aws_route_table.bastion_rt.id
# }
