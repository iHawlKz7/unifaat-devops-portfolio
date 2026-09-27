output "db_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.main.address
}

output "db_name" {
  description = "Nome do database"
  value       = aws_db_instance.main.db_name
}

output "db_port" {
  description = "Porta do banco"
  value       = aws_db_instance.main.port
}
