output "bastion_ip" {
  value = aws_instance.postgres_bastion.public_ip
  description = "Public IP of the bastion host"
}
