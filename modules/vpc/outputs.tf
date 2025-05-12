output "vpc_id" {
  value = aws_vpc.postgres_vpc.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}
