output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_arn" {
  value = aws_db_instance.postgres.arn
}
