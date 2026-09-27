output "vpc_id" {
  description = "ID da VPC"
  value       = module.vpc.vpc_id
}

output "ec2_public_ip" {
  description = "IP publico da EC2"
  value       = module.api_server.public_ip
}

output "rds_endpoint" {
  description = "Endpoint do RDS"
  value       = module.database.db_endpoint
}
