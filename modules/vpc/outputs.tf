output "vpc_id" {
  value = aws_vpc.pg_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.pg_vpc.cidr_block
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.pg_public_subnet : subnet.id] 
}


# output "public_subnet_id" {
#   value = aws_subnet.bastion_subnet_1.id
# }
