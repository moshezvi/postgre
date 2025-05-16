output "vpc_id" {
  value = aws_vpc.postgres_vpc.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_us_east_2a.id, aws_subnet.private_subnet_us_east_2b.id, aws_subnet.private_subnet_us_east_2c.id]  
}

output "public_subnet_id" {
  value = aws_subnet.bastion_subnet_1.id
}
