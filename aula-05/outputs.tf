output "vpc_id" {
  value = aws_vpc.main.id
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "rds_address" {
  value = aws_db_instance.main.address
}

output "rds_port" {
  value = aws_db_instance.main.port
}

output "rds_database_name" {
  value = aws_db_instance.main.db_name
}

output "ec2_public_ip" {
  value = aws_instance.api.public_ip
}

output "connection_string" {
  value = "psql -h ${aws_db_instance.main.address} -U ${var.db_username} -d ${var.db_name} -p 5432"
}
