resource "aws_vpc" "postgres_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "postgres-vpc"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.postgres_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.postgres_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.postgres_vpc.id

  # No route to the IGW; this makes it "private"
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

### Adding NAT Gateway for outbound internet access
resource "aws_subnet" "bastion_subnet_1" {
  vpc_id                  = aws_vpc.postgres_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "bastion_subnet_1"
  }
}

resource "aws_internet_gateway" "bastion_igw" {
  vpc_id = aws_vpc.postgres_vpc.id

  tags = {
    Name = "bastion-igw"
  }
}

resource "aws_route_table" "bastion_rt" {
  vpc_id = aws_vpc.postgres_vpc.id
  # This route table is for the public subnet

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.bastion_subnet_1.id
  route_table_id = aws_route_table.bastion_rt.id
}
